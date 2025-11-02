import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/features/admin/widgets/service_form.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/services/service_repository.dart';

class AddServiceScreen extends ConsumerWidget {
  const AddServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: ServiceForm(
        onSave: (service) {
          _saveService(context, ref, service);
        },
      ),
    );
  }

  void _saveService(
      BuildContext context, WidgetRef ref, Service service) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(serviceRepositoryProvider).addService(service);

      if (!context.mounted) return;
      context.pop(); // Dismiss the dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service added successfully!')),
      );

      context.pop();
    } catch (e) {
      if (!context.mounted) return;
      context.pop(); // Dismiss on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add service: $e')),
      );
    }
  }
}
