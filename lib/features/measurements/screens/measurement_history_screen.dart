import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement_history.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

final measurementHistoryProvider = FutureProvider.family<List<MeasurementHistory>, String>(
  (ref, measurementId) async {
    final repository = ref.watch(measurementRepositoryProvider);
    return repository.getHistory(measurementId);
  },
);

class MeasurementHistoryScreen extends ConsumerWidget {
  final String? measurementId;
  final VoidCallback? onClose;

  const MeasurementHistoryScreen({
    super.key,
    this.measurementId,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = measurementId != null
        ? ref.watch(measurementHistoryProvider(measurementId!))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurement History'),
        leading: onClose != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              )
            : null,
      ),
      body: measurementId == null
          ? const Center(
              child: Text('Select a measurement to view its history'),
            )
          : historyAsync?.when(
              data: (history) => history.isEmpty
                  ? const Center(
                      child: Text('No history available'),
                    )
                  : ResponsiveLayout(
                      mobileBody: _buildMobileLayout(history, ref),
                      tabletBody: _buildTabletLayout(history, ref),
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ) ??
            const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildMobileLayout(List<MeasurementHistory> history, WidgetRef ref) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: ListTile(
            title: Text(
              'Changed on ${entry.timestamp.toLocal()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              '${entry.values.length} values updated',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.restore),
              onPressed: () => _restoreMeasurement(
                context,
                ref,
                entry,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabletLayout(List<MeasurementHistory> history, WidgetRef ref) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: ExpansionTile(
            title: Text(
              'Changed on ${entry.timestamp.toLocal()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              '${entry.values.length} values updated',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.restore),
              onPressed: () => _restoreMeasurement(
                context,
                ref,
                entry,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: entry.values.entries.map((e) {
                    return Chip(
                      label: Text('${e.key}: ${e.value}"'),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _restoreMeasurement(
    BuildContext context,
    WidgetRef ref,
    MeasurementHistory history,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Measurement?'),
        content: const Text(
          'This will revert the measurement to this historical version. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final repository = ref.read(measurementRepositoryProvider);
      await repository.updateMeasurement(
        measurementId!,
        {'values': history.values},
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Measurement restored successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
