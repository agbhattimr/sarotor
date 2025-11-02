import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/features/admin/template_analytics_screen.dart';
import 'package:sartor_order_management/features/admin/widgets/add_edit_template_dialog.dart';
import 'package:sartor_order_management/providers/measurement_template_provider.dart';
import 'package:sartor_order_management/services/template_import_export_service.dart';

final templateImportExportServiceProvider = Provider((ref) => TemplateImportExportService());

class MeasurementTemplatesScreen extends ConsumerWidget {
  const MeasurementTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(measurementTemplatesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurement Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              final templates = await ref.read(templateImportExportServiceProvider).importTemplates();
              for (final template in templates) {
                await ref.read(measurementTemplateRepositoryProvider).addMeasurementTemplate(template);
              }
              ref.read(measurementTemplatesProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              final templates = ref.read(measurementTemplatesProvider).asData?.value;
              if (templates != null) {
                ref.read(templateImportExportServiceProvider).exportTemplates(templates);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TemplateAnalyticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddEditTemplateDialog(),
              );
            },
          ),
        ],
      ),
      body: templatesAsync.when(
        data: (templates) => ListView.builder(
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            return ListTile(
              title: Text(template.name),
              subtitle: Text(template.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AddEditTemplateDialog(template: template),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      ref
                          .read(measurementTemplateRepositoryProvider)
                          .duplicateMeasurementTemplate(template);
                      ref.read(measurementTemplatesProvider.notifier).refresh();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(measurementTemplateRepositoryProvider)
                          .deleteMeasurementTemplate(template.id);
                      ref.read(measurementTemplatesProvider.notifier).refresh();
                    },
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
