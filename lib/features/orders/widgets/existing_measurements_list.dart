import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/providers/measurement_selection_provider.dart';
import 'package:sartor_order_management/shared/components/order_card.dart';

class ExistingMeasurementsList extends ConsumerWidget {
  final List<Measurement> measurements;

  const ExistingMeasurementsList({
    super.key,
    required this.measurements,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMeasurementIds = ref.watch(selectedMeasurementsProvider);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: measurements.length,
          itemBuilder: (context, index) {
            final measurement = measurements[index];
            final isSelected = selectedMeasurementIds.contains(measurement.id);
            return OrderCard(
              measurement: measurement,
              isSelected: isSelected,
              appContext: AppContext.client,
              onTap: () {
                ref
                    .read(selectedMeasurementsProvider.notifier)
                    .toggleMeasurement(measurement.id);
              },
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Create New Measurement'),
          onPressed: () async {
            final newMeasurement =
                await context.push<Measurement>('/measurements/new');
            if (newMeasurement != null) {
              ref
                  .read(selectedMeasurementsProvider.notifier)
                  .addMeasurement(newMeasurement.id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('New measurement created and selected.'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
