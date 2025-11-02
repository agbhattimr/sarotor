import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class MeasurementHistoryScreen extends ConsumerWidget {
  final Measurement? measurement;

  const MeasurementHistoryScreen({super.key, this.measurement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (measurement == null) {
      return const Scaffold(
        appBar: null,
        body: Center(
          child: Text('Select a measurement to view its history.'),
        ),
      );
    }

    final historyAsync = ref.watch(measurementHistoryProvider(measurement!.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${measurement!.profileName} History'),
      ),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return const Center(child: Text('No history found.'));
          }
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final historyEntry = history[index];
              return ListTile(
                title: Text(
                    'Change made ${timeago.format(historyEntry.timestamp)}'),
                subtitle: Text(historyEntry.values.keys.join(', ')),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
