import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

final adminOrdersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(supabaseRepoProvider).adminFetchOrders();
});

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOrders = ref.watch(adminOrdersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ResponsiveLayout(
        mobileBody: _buildMobileLayout(asyncOrders, ref),
        tabletBody: _buildTabletLayout(asyncOrders, ref),
      ),
    );
  }

  Widget _buildMobileLayout(AsyncValue<List<Map<String, dynamic>>> asyncOrders, WidgetRef ref) {
    return asyncOrders.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (orders) => ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, i) {
          final o = orders[i];
          return ListTile(
            title: Text('Order ${o['id'].toString().substring(0, 8)} • ${o['status']}'),
            subtitle: Text('Total: ${((o['total_cents'] ?? 0) / 100.0).toStringAsFixed(2)}'),
            trailing: _buildStatusMenu(ref, o['id'] as String),
          );
        },
      ),
    );
  }

  Widget _buildTabletLayout(AsyncValue<List<Map<String, dynamic>>> asyncOrders, WidgetRef ref) {
    return asyncOrders.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (orders) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, i) {
            final o = orders[i];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text('Order ${o['id'].toString().substring(0, 8)}', style: Theme.of(context).textTheme.titleLarge),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Status: ${o['status']}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('Total: \$${((o['total_cents'] ?? 0) / 100.0).toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                trailing: _buildStatusMenu(ref, o['id'] as String),
              ),
            );
          },
        ),
      ),
    );
  }

  PopupMenuButton<String> _buildStatusMenu(WidgetRef ref, String orderId) {
    return PopupMenuButton<String>(
      onSelected: (s) => ref.read(supabaseRepoProvider)
          .adminUpdateOrderStatus(orderId, s)
          .then((_) => ref.refresh(adminOrdersProvider)),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem(value: 'pending', child: Text('pending')),
        const PopupMenuItem(value: 'in_progress', child: Text('in_progress')),
        const PopupMenuItem(value: 'ready', child: Text('ready')),
        const PopupMenuItem(value: 'completed', child: Text('completed')),
        const PopupMenuItem(value: 'cancelled', child: Text('cancelled')),
      ],
    );
  }
}
