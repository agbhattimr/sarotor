import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/features/admin/widgets/service_form.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/services/service_repository.dart';

class EditServiceScreen extends ConsumerWidget {
  final int serviceId;

  const EditServiceScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(serviceByIdProvider(serviceId));

    return serviceAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error loading service: $e'))),
      data: (service) {
        if (service == null) {
          return const Scaffold(body: Center(child: Text('Service not found')));
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Service'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteService(context, ref, service.id),
              ),
            ],
          ),
          body: ServiceForm(
            service: service,
            onSave: (updatedService) {
              _updateService(context, ref, updatedService);
            },
          ),
        );
      },
    );
  }

  void _updateService(
      BuildContext context, WidgetRef ref, Service service) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(serviceRepositoryProvider).updateService(service);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // Dismiss the dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service saved successfully!')),
      );

      GoRouter.of(context).go('/admin/services');
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Dismiss on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save service: $e')),
      );
    }
  }

  void _deleteService(BuildContext context, WidgetRef ref, int serviceId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(serviceRepositoryProvider).deleteService(serviceId);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss progress

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service deleted successfully')),
      );
      GoRouter.of(context).go('/admin/services');
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss progress
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete service: $e')),
      );
    }
  }
}
