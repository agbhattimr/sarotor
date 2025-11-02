import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/providers/measurement_template_provider.dart';

class TemplateBasedMeasurementCreator extends ConsumerStatefulWidget {
  const TemplateBasedMeasurementCreator({super.key});

  @override
  ConsumerState<TemplateBasedMeasurementCreator> createState() =>
      _TemplateBasedMeasurementCreatorState();
}

class _TemplateBasedMeasurementCreatorState
    extends ConsumerState<TemplateBasedMeasurementCreator> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(measurementTemplatesProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.library_books,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Create from Template',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Start with pre-defined measurement templates for faster profile creation.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            templatesAsync.when(
              data: (templates) => _buildTemplatesGrid(templates),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) =>
                  Center(child: Text('Error loading templates: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplatesGrid(List<MeasurementTemplate> templates) {
    if (templates.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No templates available'),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: templates.length + 1, // +1 for the custom template option
      itemBuilder: (context, index) {
        if (index == templates.length) {
          // Custom template option
          return _buildCustomTemplateCard();
        }
        final template = templates[index];
        return _buildTemplateCard(template);
      },
    );
  }

  Widget _buildTemplateCard(MeasurementTemplate template) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: _isLoading ? null : () => _createFromTemplate(template),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getTemplateIcon(template.category),
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                template.name,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                template.category,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTemplateCard() {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: _isLoading ? null : _createCustomMeasurement,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Start Blank',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Create from scratch',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTemplateIcon(String category) {
    switch (category.toLowerCase()) {
      case 'shirt':
      case 'shirts':
        return Icons.checkroom;
      case 'shalwar':
      case 'pants':
        return Icons.accessibility;
      case 'trouser':
      case 'trousers':
        return Icons.airline_seat_legroom_normal;
      case 'suit':
      case 'blazer':
        return Icons.business;
      default:
        return Icons.straighten;
    }
  }

  Future<void> _createFromTemplate(MeasurementTemplate template) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a measurement from template
      final measurement = Measurement(
        id: '',
        name: '${template.name} - ${DateTime.now().millisecondsSinceEpoch}',
        isCustom: false,
        templateId: template.id,
        measurements: template.standardMeasurements.map(
          (key, value) => MapEntry(key, value.toDouble()),
        ),
        createdAt: DateTime.now(),
      );

      if (mounted) {
        // Navigate to the measurement form with the template-based measurement
        final result = await context.push(
          '/measurements/new',
          extra: measurement,
        );
        if (result != null && result is Measurement) {
          // Handle the created measurement if needed
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating measurement: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createCustomMeasurement() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Navigate to blank measurement form
      final result = await context.push('/measurements/new');
      if (result != null && result is Measurement) {
        // Handle the created measurement if needed
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating measurement: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
