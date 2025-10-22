import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/features/measurements/measurement_form_screen_new.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';

class MeasurementsListScreen extends ConsumerWidget {
  const MeasurementsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementsAsync = ref.watch(measurementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurements'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MeasurementFormScreenNew(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: measurementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (measurements) {
          if (measurements.isEmpty) {
            return const Center(child: Text('No measurements found.'));
          }
          return ListView.builder(
            itemCount: measurements.length,
            itemBuilder: (context, index) {
              final measurement = measurements[index];
              return ListTile(
                title: Text(measurement.profileName),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MeasurementFormScreenNew(
                        measurement: measurement,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
