import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

final orderManagementProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(supabaseRepoProvider).adminFetchOrders();
});

final filteredOrdersProvider = StateNotifierProvider<OrderFilterNotifier, List<Map<String, dynamic>>>((ref) {
  return OrderFilterNotifier();
});

class OrderFilterNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  OrderFilterNotifier() : super([]);

  List<Map<String, dynamic>> _originalOrders = [];
  String? _currentFilter;
  String _searchQuery = '';

  String? get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  void updateOriginalOrders(List<Map<String, dynamic>> orders) {
    _originalOrders = orders;
    _applyFilter();
  }

  void setStatusFilter(String? status) {
    _currentFilter = status;
    _applyFilter();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    List<Map<String, dynamic>> filteredOrders;
    if (_currentFilter == null || _currentFilter!.isEmpty) {
      filteredOrders = _originalOrders;
    } else {
      filteredOrders = _originalOrders.where((order) => order['status'] == _currentFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredOrders = filteredOrders.where((order) {
        final orderId = order['id'].toString().toLowerCase();
        final userId = order['user_id']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return orderId.contains(query) || userId.contains(query);
      }).toList();
    }
    state = filteredOrders;
  }
}

class OrderManagementScreen extends ConsumerWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(orderManagementProvider, (previous, next) {
      if (next.hasValue) {
        ref.read(filteredOrdersProvider.notifier).updateOriginalOrders(next.value!);
      }
    });
    final allOrdersAsync = ref.watch(orderManagementProvider);
    final filteredOrders = ref.watch(filteredOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, ref),
          ),
        ],
      ),
      body: allOrdersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading orders: $e')),
        data: (orders) {
          if (filteredOrders.isEmpty && orders.isNotEmpty) {
            // Show a loading indicator while the filter is being applied for the first time
            return const Center(child: CircularProgressIndicator());
          }
          return ResponsiveLayout(
            mobileBody: _buildMobileOrderList(filteredOrders, context, ref),
            tabletBody: _buildTabletOrderList(filteredOrders, context, ref),
          );
        },
      ),
    );
  }

  Widget _buildMobileOrderList(List<Map<String, dynamic>> orders, BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(orderManagementProvider);
      },
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Order ${order['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: ${order['status']} • Total: PKR${((order['total_cents'] ?? 0) / 100.0).toStringAsFixed(2)}'),
                  Text('Created: ${DateTime.parse(order['created_at']).toString().substring(0, 19)}'),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (status) => _updateOrderStatus(ref, order['id'] as String, status),
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem(value: 'pending', child: Text('Pending')),
                  const PopupMenuItem(value: 'in_progress', child: Text('In Progress')),
                  const PopupMenuItem(value: 'ready', child: Text('Ready')),
                  const PopupMenuItem(value: 'completed', child: Text('Completed')),
                  const PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
                ],
              ),
              onTap: () => _showOrderDetailsDialog(context, order),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabletOrderList(List<Map<String, dynamic>> orders, BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(orderManagementProvider);
      },
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Order ID')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Created')),
            DataColumn(label: Text('Actions')),
          ],
          rows: orders.map((order) => DataRow(
            cells: [
              DataCell(Text(order['id'].toString().substring(0, 8))),
              DataCell(_buildStatusChip(order['status'] as String)),
              DataCell(Text('PKR${((order['total_cents'] ?? 0) / 100.0).toStringAsFixed(2)}')),
              DataCell(Text(DateTime.parse(order['created_at']).toString().substring(0, 16))),
              DataCell(_buildActionButtons(order, ref)),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'in_progress':
        color = Colors.blue;
        break;
      case 'ready':
        color = Colors.green;
        break;
      case 'completed':
        color = Colors.teal;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(status.replaceAll('_', ' ').toUpperCase(), style: const TextStyle(fontSize: 10)),
      backgroundColor: color.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> order, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
          onPressed: () => _showOrderDetailsDialog(ref.context, order),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          onSelected: (status) => _updateOrderStatus(ref, order['id'] as String, status),
          itemBuilder: (context) => <PopupMenuEntry<String>>[
            const PopupMenuItem(value: 'pending', child: Text('Pending')),
            const PopupMenuItem(value: 'in_progress', child: Text('In Progress')),
            const PopupMenuItem(value: 'ready', child: Text('Ready')),
            const PopupMenuItem(value: 'completed', child: Text('Completed')),
            const PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
          ],
        ),
      ],
    );
  }

  void _updateOrderStatus(WidgetRef ref, String orderId, String status) async {
    final messenger = ScaffoldMessenger.of(ref.context);
    try {
      await ref.read(supabaseRepoProvider).adminUpdateOrderStatus(orderId, status);
      ref.invalidate(orderManagementProvider);
      messenger.showSnackBar(
        SnackBar(content: Text('Order status updated to $status')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to update order: $e')),
      );
    }
  }

  void _showOrderDetailsDialog(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order ${order['id'].toString().substring(0, 8)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${order['status']}'),
            Text('Total: PKR${((order['total_cents'] ?? 0) / 100.0).toStringAsFixed(2)}'),
            Text('Created: ${DateTime.parse(order['created_at']).toString().substring(0, 19)}'),
            if (order['user_id'] != null) Text('User ID: ${order['user_id'].toString().substring(0, 8)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(filteredOrdersProvider.notifier);
    String? selectedStatus = notifier.currentFilter;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('All'),
                    leading: Radio<String?>(
                      value: null,
                      // ignore: deprecated_member_use
                      groupValue: selectedStatus,
                      // ignore: deprecated_member_use
                      onChanged: (String? value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Pending'),
                    leading: Radio<String>(
                      value: 'pending',
                      // ignore: deprecated_member_use
                      groupValue: selectedStatus,
                      // ignore: deprecated_member_use
                      onChanged: (String? value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('In Progress'),
                    leading: Radio<String>(
                      value: 'in_progress',
                      // ignore: deprecated_member_use
                      groupValue: selectedStatus,
                      // ignore: deprecated_member_use
                      onChanged: (String? value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Ready'),
                    leading: Radio<String>(
                      value: 'ready',
                      // ignore: deprecated_member_use
                      groupValue: selectedStatus,
                      // ignore: deprecated_member_use
                      onChanged: (String? value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Completed'),
                    leading: Radio<String>(
                      value: 'completed',
                      // ignore: deprecated_member_use
                      groupValue: selectedStatus,
                      // ignore: deprecated_member_use
                      onChanged: (String? value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Cancelled'),
                    leading: Radio<String>(
                      value: 'cancelled',
                      // ignore: deprecated_member_use
                      groupValue: selectedStatus,
                      // ignore: deprecated_member_use
                      onChanged: (String? value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                notifier.setStatusFilter(selectedStatus);
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(filteredOrdersProvider.notifier);
    final controller = TextEditingController(text: notifier.searchQuery);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Orders'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter order ID or user info'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              notifier.setSearchQuery('');
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.setSearchQuery(controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
