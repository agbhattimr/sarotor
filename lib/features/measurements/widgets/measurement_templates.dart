import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';

final templatesProvider = FutureProvider<List<MeasurementTemplate>>((ref) async {
  final repository = ref.watch(measurementRepositoryProvider);
  return repository.getTemplates();
});

class MeasurementTemplates extends ConsumerStatefulWidget {
  final String? userId;
  final Map<String, double>? currentMeasurements;
  final Function(Map<String, double>) onApplyTemplate;

  const MeasurementTemplates({
    super.key,
    this.userId,
    this.currentMeasurements,
    required this.onApplyTemplate,
  });

  @override
  ConsumerState<MeasurementTemplates> createState() => _MeasurementTemplatesState();
}

class _MeasurementTemplatesState extends ConsumerState<MeasurementTemplates> {
  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(templatesProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Measurement Templates',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: templatesAsync.when(
              data: (templates) {
                if (templates.isEmpty) {
                  return const Center(
                    child: Text('No templates available'),
                  );
                }

                return ListView.builder(
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return Card(
                      child: ListTile(
                        title: Text(template.name),
                        subtitle: Text(template.description),
                        trailing: FilledButton(
                          onPressed: () => widget.onApplyTemplate(template.defaultValues),
                          child: const Text('Apply'),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
