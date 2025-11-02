import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/providers/measurement_selection_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultMeasurementSelector extends ConsumerStatefulWidget {
  const DefaultMeasurementSelector({super.key});

  @override
  ConsumerState<DefaultMeasurementSelector> createState() =>
      _DefaultMeasurementSelectorState();
}

class _DefaultMeasurementSelectorState
    extends ConsumerState<DefaultMeasurementSelector> {
  String? _defaultMeasurementId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDefaultMeasurement();
      }
    });
  }

  Future<void> _loadDefaultMeasurement() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _defaultMeasurementId = prefs.getString('default_measurement_id');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _setDefaultMeasurement(String measurementId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('default_measurement_id', measurementId);
      setState(() {
        _defaultMeasurementId = measurementId;
      });

      // Auto-select the default measurement if none is selected
      final selectedMeasurements = ref.read(selectedMeasurementsProvider);
      if (selectedMeasurements.isEmpty) {
        ref.read(selectedMeasurementsProvider.notifier).addMeasurement(measurementId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Default measurement set successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error setting default measurement: $e')),
        );
      }
    }
  }

  Future<void> _clearDefaultMeasurement() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('default_measurement_id');
      setState(() {
        _defaultMeasurementId = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Default measurement cleared')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing default measurement: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final measurementsAsync = ref.watch(measurementsProvider);

    if (_isLoading) {
      return const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Default Measurement',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Set a frequently used measurement as your default for quick selection.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            measurementsAsync.when(
              data: (measurements) => _buildDefaultMeasurementContent(measurements),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultMeasurementContent(List<Measurement> measurements) {
    if (measurements.isEmpty) {
      return Center(
        child: Text(
          'Create a measurement first to set as default',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    final defaultMeasurement = measurements
        .cast<Measurement?>()
        .firstWhere((m) => m?.id == _defaultMeasurementId, orElse: () => null);

    return Column(
      children: [
        if (defaultMeasurement != null) ...[
          _buildCurrentDefaultCard(defaultMeasurement),
          const SizedBox(height: 16),
          _buildChangeDefaultButton(measurements),
        ] else ...[
          _buildNoDefaultSet(measurements),
        ],
      ],
    );
  }

  Widget _buildCurrentDefaultCard(Measurement measurement) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  measurement.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Default measurement profile',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.error),
            onPressed: _clearDefaultMeasurement,
            tooltip: 'Clear default measurement',
          ),
        ],
      ),
    );
  }

  Widget _buildChangeDefaultButton(List<Measurement> measurements) {
    return OutlinedButton.icon(
      onPressed: () => _showMeasurementSelectionDialog(measurements),
      icon: const Icon(Icons.edit),
      label: const Text('Change Default'),
    );
  }

  Widget _buildNoDefaultSet(List<Measurement> measurements) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Icon(
          Icons.star_border,
          size: 48,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 8),
        Text(
          'No default measurement set',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Select a measurement to use as your default for quick access.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _showMeasurementSelectionDialog(measurements),
          icon: const Icon(Icons.star),
          label: const Text('Set Default Measurement'),
        ),
      ],
    );
  }

  void _showMeasurementSelectionDialog(List<Measurement> measurements) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Default Measurement'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: measurements.length,
            itemBuilder: (context, index) {
              final measurement = measurements[index];
              final isSelected = measurement.id == _defaultMeasurementId;

              return ListTile(
                leading: Icon(
                  isSelected ? Icons.star : Icons.star_border,
                  color: isSelected ? Theme.of(context).primaryColor : null,
                ),
                title: Text(measurement.name),
                subtitle: Text(
                  'Created ${measurement.createdAt.toString().split(' ')[0]}',
                ),
                selected: isSelected,
                onTap: () {
                  _setDefaultMeasurement(measurement.id);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
