import 'package:flutter/material.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/features/measurements/screens/measurement_history_screen.dart';

class MeasurementCard extends StatelessWidget {
  final Measurement measurement;
  final MeasurementTemplate? template;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const MeasurementCard({
    super.key,
    required this.measurement,
    this.template,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    measurement.profileName ?? '-',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (template != null)
                    Chip(
                      label: Text(template!.name),
                      backgroundColor: Colors.blue.shade100,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _buildMeasurementPreview(context),
              const SizedBox(height: 8),
              if (measurement.isCustom)
                const Text(
                  'Custom Measurement',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                )
              else if (template != null)
                Text(
                  'Based on ${template!.name}',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MeasurementHistoryScreen(
                              measurement: measurement,
                            ),
                          ),
                        );
                      },
                    ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementPreview(BuildContext context) {
    final previewMeasurements = {
      'Chest': measurement.measurements['chest'],
      'Waist': measurement.measurements['waist'],
      'Arm Length': measurement.measurements['arm_length'],
    };

    return Wrap(
      spacing: 16.0,
      runSpacing: 8.0,
      children: previewMeasurements.entries
          .where((entry) => entry.value != null)
          .map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  Text(
                    '${entry.value}"',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ))
          .toList(),
    );
  }
}
