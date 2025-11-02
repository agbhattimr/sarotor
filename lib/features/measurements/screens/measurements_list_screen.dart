import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/features/measurements/screens/measurement_comparison_screen.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';
import 'package:sartor_order_management/providers/measurement_template_provider.dart';
import 'package:sartor_order_management/features/measurements/widgets/measurement_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeasurementsListScreen extends ConsumerStatefulWidget {
  final Function(String)? onMeasurementSelected;
  final String? selectedMeasurementId;

  const MeasurementsListScreen({
    super.key,
    this.onMeasurementSelected,
    this.selectedMeasurementId,
  });

  @override
  ConsumerState<MeasurementsListScreen> createState() => _MeasurementsListScreenState();
}

class _MeasurementsListScreenState extends ConsumerState<MeasurementsListScreen> {
  final List<Measurement> _selectedMeasurements = [];

  void _toggleMeasurementSelection(Measurement measurement) {
    setState(() {
      if (_selectedMeasurements.contains(measurement)) {
        _selectedMeasurements.remove(measurement);
      } else {
        if (_selectedMeasurements.length < 2) {
          _selectedMeasurements.add(measurement);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only compare two measurements at a time.')),
          );
        }
      }
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/no_results.svg',
              height: 150,
            ),
            const SizedBox(height: 24),
            Text(
              'No Measurement Profiles Found',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a new measurement profile to save and reuse your measurements for future orders.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/client/measurements/new'),
              icon: const Icon(Icons.add),
              label: const Text('Create New Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final measurementsAsync = ref.watch(measurementsProvider);
    final templatesAsync = ref.watch(measurementTemplatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Measurements'),
        actions: [
          if (_selectedMeasurements.length == 2)
            IconButton(
              icon: const Icon(Icons.compare_arrows),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MeasurementComparisonScreen(
                      measurement1: _selectedMeasurements[0],
                      measurement2: _selectedMeasurements[1],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: measurementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (measurements) {
          if (measurements.isEmpty) {
            return _buildEmptyState(context);
          }

          return templatesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
            data: (templates) {
              return ListView.builder(
                itemCount: measurements.length,
                itemBuilder: (context, index) {
                  final measurement = measurements[index];
                  final template = templates.firstWhere(
                    (t) => t.id == measurement.templateId,
                    orElse: () => const MeasurementTemplate(id: '', name: 'Unknown', description: '', standardMeasurements: {}, measurementRanges: {}, category: ''),
                  );
                  final isSelected = _selectedMeasurements.contains(measurement);
                  return GestureDetector(
                    onLongPress: () => _toggleMeasurementSelection(measurement),
                    onTap: () {
                      if (_selectedMeasurements.isNotEmpty) {
                        _toggleMeasurementSelection(measurement);
                      } else {
                        context.go('/client/measurements/new', extra: measurement);
                      }
                    },
                    child: Container(
                      color: isSelected ? Colors.blue.withAlpha(51) : Colors.transparent,
                      child: MeasurementCard(
                        measurement: measurement,
                        template: template,
                        onTap: () => context.go('/client/measurements/new', extra: measurement),
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Measurement'),
                              content: const Text(
                                  'Are you sure you want to delete this measurement profile?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final navigator = Navigator.of(context);
                                    await ref
                                        .read(measurementRepositoryProvider)
                                        .deleteMeasurement(measurement.id);
                                    ref.invalidate(measurementsProvider);
                                    navigator.pop();
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'measurements_list_screen_fab',
        onPressed: () => context.go('/client/measurements/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
