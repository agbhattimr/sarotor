import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart' hide selectedMeasurementsProvider, measurementValidationProvider;
import 'package:sartor_order_management/providers/measurement_selection_provider.dart';
import 'package:sartor_order_management/features/orders/widgets/custom_radio_group.dart';

class MeasurementsDetailsStep extends ConsumerWidget {
  const MeasurementsDetailsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final measurementsAsync = ref.watch(measurementsProvider);
    final servicesRequiringMeasurement =
        cart.items.values.where((item) => item.requiresMeasurement).toList();
    final selectedMeasurements = ref.watch(selectedMeasurementsProvider);
    final validationResultAsync = ref.watch(measurementValidationProvider);

    if (servicesRequiringMeasurement.isEmpty) {
      return const Center(
        child: Text("No services requiring measurements in the cart."),
      );
    }

    return measurementsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (measurements) {
        if (measurements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No measurements found.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.push('/measurement-form');
                  },
                  child: const Text('Create New Measurement'),
                ),
              ],
            ),
          );
        }

        return validationResultAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Validation Error: $err')),
          data: (validationResult) {
            return ListView.builder(
              itemCount: servicesRequiringMeasurement.length,
              itemBuilder: (context, index) {
                final cartItem = servicesRequiringMeasurement[index];
                final selectedMeasurementId = selectedMeasurements.isNotEmpty
                    ? selectedMeasurements.first
                    : null;

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('Select a measurement profile:'),
                        CustomRadioGroup<String>(
                          initialValue: selectedMeasurementId,
                          onChanged: (String? value) {
                            if (value != null) {
                              ref
                                  .read(selectedMeasurementsProvider.notifier)
                                  .toggleMeasurement(value);
                            }
                          },
                          items: measurements.map((measurement) {
                            return CustomRadioListTile<String>(
                              title: Text(measurement.profileName),
                              value: measurement.id.toString(),
                            );
                          }).toList(),
                        ),
                        if (!validationResult.isValid)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              validationResult.message,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
