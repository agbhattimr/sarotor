import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';
import 'package:sartor_order_management/features/measurements/measurement_form_screen_new.dart';

final templatesProvider = FutureProvider<List<MeasurementTemplate>>((ref) {
  final repository = ref.watch(measurementRepositoryProvider);
  return repository.getTemplates();
});

class MeasurementTemplatesScreen extends ConsumerWidget {
  final String? measurementId;
  final VoidCallback? onClose;

  const MeasurementTemplatesScreen({
    super.key,
    this.measurementId,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurement Templates'),
        leading: onClose != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              )
            : null,
      ),
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (templates) {
          if (templates.isEmpty) {
            return const Center(child: Text('No templates available'));
          }

          return ResponsiveLayout(
            mobileBody: _buildListView(templates, ref, context),
            tabletBody: _buildGridView(templates, 2, ref, context),
            desktopBody: _buildGridView(templates, 4, ref, context),
          );
        },
      ),
    );
  }

  void _handleTemplateSelection(BuildContext context, WidgetRef ref, MeasurementTemplate template) async {
    if (measurementId != null) {
      // Apply template to existing measurement
      // For simplicity, update the measurement with template measurements
      final repo = ref.read(measurementRepositoryProvider);
      final updateData = {
        'measurements': template.standardMeasurements,
        'template_id': template.id,
        'is_custom': false,
      };
      try {
        await repo.updateMeasurement(measurementId!, updateData);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Applied template ${template.name} to measurement')),
          );
        }
        onClose?.call();
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to apply template: $error')),
          );
        }
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MeasurementFormScreenNew(initialTemplate: template),
        ),
      );
    }
  }

  Widget _buildListView(List<MeasurementTemplate> templates, WidgetRef ref, BuildContext context) {
    return ListView.builder(
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return ListTile(
          title: Text(template.name),
          subtitle: Text(template.description),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _handleTemplateSelection(context, ref, template),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<MeasurementTemplate> templates, int crossAxisCount, WidgetRef ref, BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return Card(
          child: InkWell(
            onTap: () => _handleTemplateSelection(context, ref, template),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(template.name, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(template.description, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
