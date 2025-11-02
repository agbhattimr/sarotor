import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/features/measurements/measurement_form_screen_new.dart';
import 'package:sartor_order_management/features/measurements/widgets/measurement_card.dart';
import 'package:sartor_order_management/features/measurements/widgets/template_selection_grid.dart';
import 'package:sartor_order_management/features/orders/widgets/default_measurement_selector.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';
import 'package:sartor_order_management/providers/measurement_template_provider.dart';

class MeasurementsListScreen extends ConsumerStatefulWidget {
  const MeasurementsListScreen({super.key});

  @override
  ConsumerState<MeasurementsListScreen> createState() => _MeasurementsListScreenState();
}

class _MeasurementsListScreenState extends ConsumerState<MeasurementsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurements'),
        actions: [
          IconButton(
            onPressed: () => _showAddMeasurementDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Measurements'),
            Tab(text: 'Templates'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMeasurementsTab(),
          _buildTemplatesTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              heroTag: 'measurements_list_fab',
              onPressed: () => _showAddMeasurementDialog(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildMeasurementsTab() {
    final measurementsAsync = ref.watch(measurementsProvider);

    return measurementsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (measurements) {
        if (measurements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.straighten, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('No measurements found.'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddMeasurementDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Create your first measurement'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            const DefaultMeasurementSelector(),
            Expanded(
              child: ListView.builder(
                itemCount: measurements.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final measurement = measurements[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MeasurementCard(
                      measurement: measurement,
                      onTap: () => _editMeasurement(measurement),
                      onDelete: () => _confirmDeleteMeasurement(measurement),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTemplatesTab() {
    final templatesAsync = ref.watch(measurementTemplatesProvider);

    return templatesAsync.when(
      data: (templates) {
        if (templates.isEmpty) {
          return const Center(
            child: Text('No templates available.\nTemplates will be added by administrators.'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: TemplateSelectionGrid(
                templates: templates,
                onTemplateSelected: _createMeasurementFromTemplate,
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading templates: $error')),
    );
  }

  void _showAddMeasurementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Measurement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Start from Scratch'),
              subtitle: const Text('Create a custom measurement'),
              onTap: () {
                Navigator.of(context).pop();
                _createCustomMeasurement();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('Use Template'),
              subtitle: const Text('Create based on a standard template'),
              onTap: () {
                Navigator.of(context).pop();
                _tabController.animateTo(1); // Switch to Templates tab
              },
            ),
          ],
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

  void _createCustomMeasurement() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MeasurementFormScreenNew(),
      ),
    );
  }

  void _createMeasurementFromTemplate(MeasurementTemplate template) {
    // Create a new measurement with the template's measurements
    final measurement = Measurement(
      id: '',
      name: '${template.name} - ${DateTime.now().millisecondsSinceEpoch}',
      templateId: template.id,
      isCustom: false,
      measurements: template.standardMeasurements.map((key, value) => MapEntry(key, value.toDouble())),
      createdAt: DateTime.now(),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MeasurementFormScreenNew(
          measurement: measurement,
        ),
      ),
    );
  }

  void _editMeasurement(dynamic measurement) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MeasurementFormScreenNew(
          measurement: measurement,
        ),
      ),
    );
  }

  void _confirmDeleteMeasurement(dynamic measurement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Measurement'),
        content: Text(
          'Are you sure you want to delete "${measurement.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteMeasurement(measurement.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteMeasurement(String measurementId) {
    ref
        .read(measurementRepositoryProvider)
        .deleteMeasurement(measurementId)
        .then((_) {
          ref.invalidate(measurementsProvider);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Measurement deleted successfully')),
            );
          }
        })
        .catchError((error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error deleting measurement: $error')),
            );
          }
        });
  }
}
