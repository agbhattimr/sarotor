import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/providers/measurement_template_provider.dart';

class TemplateSelectionGrid extends ConsumerWidget {
  final List<MeasurementTemplate>? templates;
  final Function(MeasurementTemplate) onTemplateSelected;
  final String? selectedTemplateId;

  const TemplateSelectionGrid({
    super.key,
    this.templates,
    required this.onTemplateSelected,
    this.selectedTemplateId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (templates != null) {
      return _buildGrid(context, templates!);
    }

    final templatesAsync = ref.watch(measurementTemplatesProvider);

    return templatesAsync.when(
      data: (templates) {
        return _buildGrid(context, templates);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildGrid(BuildContext context, List<MeasurementTemplate> templates) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        final isSelected = template.id == selectedTemplateId;
        return GestureDetector(
          onTap: () => onTemplateSelected(template),
          child: Card(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withAlpha(25)
                : null,
            child: Stack(
              children: [
                Center(
                  child: Text(template.name),
                ),
                if (isSelected)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.check_circle, color: Colors.green),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
