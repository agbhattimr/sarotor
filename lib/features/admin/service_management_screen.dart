import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

final adminServicesProvider = StreamProvider<List<Service>>((ref) {
  return ref.watch(serviceRepositoryProvider).getServices();
});

class ServiceManagementScreen extends ConsumerWidget {
  const ServiceManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncServices = ref.watch(adminServicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/dashboard'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(adminServicesProvider);
        },
        child: ResponsiveLayout(
          mobileBody: _buildMobileLayout(context, asyncServices, ref),
          tabletBody: _buildTabletLayout(context, asyncServices, ref),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_service_fab',
        onPressed: () => context.go('/admin/services/add'),
        tooltip: 'Add Service',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AsyncValue<List<Service>> asyncServices, WidgetRef ref) {
    return asyncServices.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading services: $e')),
      data: (services) => ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: service.imageUrl != null && service.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        service.imageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    )
                  : const Icon(Icons.image, size: 50),
              title: Text(service.name ?? 'Unnamed Service'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${service.category.name} • PKR${service.price.toStringAsFixed(2)}'),
                  Chip(
                    label: Text(service.isActive ? 'Active' : 'Inactive'),
                    backgroundColor: service.isActive
                        ? Colors.green.withAlpha(26)
                        : Colors.red.withAlpha(26),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (action) =>
                    _handleServiceAction(context, action, service, ref),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                      value: 'toggle_active',
                      child: Text('Toggle Active/Inactive')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, AsyncValue<List<Service>> asyncServices, WidgetRef ref) {
    return asyncServices.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading services: $e')),
      data: (services) => SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Services',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: services.map((service) => DataRow(
                  cells: [
                    DataCell(Text(service.name ?? 'Unnamed')),
                    DataCell(Text(service.category.name)),
                    DataCell(Text('PKR${service.price.toStringAsFixed(2)}')),
                    DataCell(_buildStatusChip(service.isActive)),
                    DataCell(
                      PopupMenuButton<String>(
                        onSelected: (action) => _handleServiceAction(context, action, service, ref),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'toggle_active', child: Text('Toggle Active/Inactive')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  ],
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isActive) {
    return Chip(
      label: Text(isActive ? 'Active' : 'Inactive'),
      backgroundColor: isActive ? Colors.green.withAlpha(26) : Colors.red.withAlpha(26),
      labelStyle: TextStyle(color: isActive ? Colors.green : Colors.red, fontSize: 12),
    );
  }

  void _handleServiceAction(BuildContext context, String action, Service service, WidgetRef ref) {
    switch (action) {
      case 'edit':
        _showEditServiceDialog(context, service);
        break;
      case 'toggle_active':
        _toggleServiceActive(service, ref);
        break;
      case 'delete':
        _showDeleteServiceDialog(context, service, ref);
        break;
    }
  }

  void _showEditServiceDialog(BuildContext context, Service service) {
    context.go('/admin/services/${service.id}/edit');
  }

  void _toggleServiceActive(Service service, WidgetRef ref) async {
    final updatedService = service.copyWith(isActive: !service.isActive);
    await ref.read(serviceRepositoryProvider).updateService(updatedService);
    ref.invalidate(adminServicesProvider);
  }

  void _showDeleteServiceDialog(BuildContext context, Service service, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        return AlertDialog(
          title: const Text('Delete Service'),
          content: Text('Are you sure you want to delete "${service.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => navigator.pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await ref.read(serviceRepositoryProvider).deleteService(service.id);
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Service "${service.name}" deleted successfully'),
                    duration: const Duration(seconds: 2),
                  ),
                );
                ref.invalidate(adminServicesProvider);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
