import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';
import 'package:sartor_order_management/features/measurements/measurement_form_screen_new.dart';

class MeasurementDetailScreen extends ConsumerWidget {
  final String measurementId;
  final VoidCallback onClose;

  const MeasurementDetailScreen({
    required this.measurementId,
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMeasurements = ref.watch(measurementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurement Details'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
        actions: [
          asyncMeasurements.when(
            data: (measurements) {
              final measurement = measurements.firstWhere((m) => m.id == measurementId, orElse: () => const Measurement(id: '', userId: '', profileName: ''));
              if (measurement.id.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MeasurementFormScreenNew(measurement: measurement),
                    ),
                  );
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          )
        ],
      ),
      body: asyncMeasurements.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (measurements) {
          final measurement = measurements.firstWhere((m) => m.id == measurementId, orElse: () => const Measurement(id: '', userId: '', profileName: ''));

          if (measurement.id.isEmpty) {
            return const Center(child: Text('Measurement not found'));
          }

          return ResponsiveLayout(
            mobileBody: _buildMobileLayout(measurement),
            tabletBody: _buildTabletLayout(measurement),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(Measurement measurement) {
    final measurementData = measurement.measurements;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(measurement.profileName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...measurementData.entries.map((entry) {
            if (entry.value == null) return const SizedBox.shrink();
            return ListTile(
              title: Text(entry.key),
              trailing: Text('${entry.value}"'),
            );
          }).toList(),
          if (measurement.notes != null && measurement.notes!.isNotEmpty) ...[
            const Divider(),
            const Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(measurement.notes!),
          ]
        ],
      ),
    );
  }

  Widget _buildTabletLayout(Measurement measurement) {
    final measurementData = measurement.measurements;
    final entries = measurementData.entries.where((e) => e.value != null).toList();
    final half = (entries.length / 2).ceil();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(measurement.profileName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: entries.sublist(0, half).map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      trailing: Text('${entry.value}"'),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: entries.sublist(half).map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      trailing: Text('${entry.value}"'),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          if (measurement.notes != null && measurement.notes!.isNotEmpty) ...[
            const Divider(),
            const Text('Notes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(measurement.notes!),
          ]
        ],
      ),
    );
  }
}
