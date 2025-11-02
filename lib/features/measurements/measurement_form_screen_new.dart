import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/providers/measurement_template_provider.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';
import 'package:sartor_order_management/features/measurements/widgets/measurement_guides.dart';
import 'package:sartor_order_management/features/measurements/widgets/measurement_input_widget.dart';
import 'package:sartor_order_management/features/measurements/widgets/template_selection_grid.dart';
import 'package:sartor_order_management/utils/measurement_validator.dart';

class MeasurementFormScreenNew extends ConsumerStatefulWidget {
  final Measurement? measurement;
  final MeasurementTemplate? initialTemplate;

  const MeasurementFormScreenNew({
    super.key,
    this.measurement,
    this.initialTemplate,
  });

  // Constructor that extracts measurement from route extra
  factory MeasurementFormScreenNew.fromRoute(Object? extra) {
    return MeasurementFormScreenNew(
      measurement: extra is Measurement ? extra : null,
    );
  }

  @override
  ConsumerState<MeasurementFormScreenNew> createState() =>
      _MeasurementFormScreenNewState();
}

class _MeasurementFormScreenNewState
    extends ConsumerState<MeasurementFormScreenNew> {
  final _formKey = GlobalKey<FormState>();
  late Measurement _measurement;
  bool _isLoading = false;
  final Map<String, MeasurementController> _controllers = {};
  String? _selectedMeasurement;
  List<ValidationAlert> _validationAlerts = [];

  @override
  void initState() {
    super.initState();
    _measurement = widget.measurement ??
        Measurement(
          id: '',
          name: '',
          isCustom: true,
          measurements: {},
          createdAt: DateTime.now(),
        );

    if (widget.initialTemplate != null && widget.measurement == null) {
      _measurement = _measurement.copyWith(
        templateId: widget.initialTemplate!.id,
        isCustom: false,
        measurements: widget.initialTemplate!.standardMeasurements.map((key, value) => MapEntry(key, value.toDouble())),
      );
    }

    _measurement.measurements.forEach((key, value) {
      _controllers[key] = MeasurementController(
        initialValue: value,
        onChanged: (newValue) {
          final newMeasurements =
              Map<String, dynamic>.from(_measurement.measurements);
          newMeasurements[key] = newValue;
          _measurement = _measurement.copyWith(measurements: newMeasurements);
          if (_measurement.templateId != null) {
            _measurement = _measurement.copyWith(isCustom: true);
          }
          setState(() {
            _validationAlerts = MeasurementValidator.validate(_measurement);
          });
        },
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.measurement == null ? 'Add Measurement' : 'Edit Measurement'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            )
          else
            IconButton(
              onPressed: _saveMeasurement,
              icon: const Icon(Icons.save),
              tooltip: 'Save Measurement',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ResponsiveLayout(
          mobileBody: _buildMobileLayout(),
          tabletBody: _buildTabletLayout(),
          desktopBody: _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _buildFormFields(),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: _buildFormFields(),
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // MeasurementCharts(measurement: _measurement),
                const SizedBox(height: 24),
                MeasurementGuides(selectedMeasurement: _selectedMeasurement),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: _buildFormFields(),
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        const Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            // child: const MeasurementCharts(measurement: _measurement),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child:
                MeasurementGuides(selectedMeasurement: _selectedMeasurement),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFormFields() {
    return [
      if (widget.measurement?.templateId != null)
        Tooltip(
          message: 'Reset all measurements to the original template values',
          child: ElevatedButton(
            onPressed: () async {
              final templates = ref.read(measurementTemplatesProvider);
              final template = templates.asData!.value.firstWhere((t) => t.id == widget.measurement!.templateId!);
              setState(() {
                _measurement = _measurement.copyWith(
                  measurements: (template as Map<String, dynamic>).map(
                    (key, value) => MapEntry(key, value.toDouble()),
                  ),
                );
                _measurement.measurements.forEach((key, value) {
                  _controllers[key]?.value = value;
                });
              });
            },
            child: const Text('Reset to Template'),
          ),
        ),
      Tooltip(
        message: 'Create a new measurement profile from a template',
        child: ElevatedButton(
          onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => TemplateSelectionGrid(
              selectedTemplateId: _measurement.templateId,
              onTemplateSelected: (template) {
                setState(() {
                    _measurement = _measurement.copyWith(
                      templateId: template.id,
                      isCustom: false,
                      measurements: template.standardMeasurements.map((key, value) => MapEntry(key, value.toDouble())),
                    );
                    _measurement.measurements.forEach((key, value) {
                      _controllers[key]?.value = value;
                    });
                  });
                  Navigator.of(context).pop();
                },
              ),
            );
          },
          child: const Text('Create from Template'),
        ),
      ),
      const SizedBox(height: 16),
      TextFormField(
        initialValue: _measurement.name,
        decoration: const InputDecoration(
          labelText: 'Profile Name',
          helperText: 'Enter a unique name for this measurement profile',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a profile name';
          }
          return null;
        },
        onSaved: (value) {
          _measurement = _measurement.copyWith(name: value!);
        },
      ),
      const SizedBox(height: 16),
      ..._buildMeasurementInputFields(context),
      if (_validationAlerts.isNotEmpty)
        _buildValidationAlerts(),
      const SizedBox(height: 16),
      TextFormField(
        initialValue: _measurement.notes,
        decoration: const InputDecoration(
          labelText: 'Notes',
          helperText: 'Add any relevant notes for this measurement',
        ),
        onSaved: (value) {
          _measurement = _measurement.copyWith(notes: value);
        },
      ),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: _saveMeasurement,
        child: const Text('Save Measurement'),
      ),
    ];
  }

  List<Widget> _buildMeasurementInputFields(BuildContext context) {
    // Helper to create a text input field
    Widget buildTextField(String label) {
      _controllers.putIfAbsent(label, () => MeasurementController());
      return MeasurementInputWidget(
        label: label,
        controller: _controllers[label]!,
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              _selectedMeasurement = label;
            });
          }
        },
      );
    }

    // Helper to create a checkbox
    Widget buildCheckbox(String label) {
      _controllers.putIfAbsent(label, () => MeasurementController(initialValue: 0.0));
      return CheckboxListTile(
        title: Text(label),
        value: _controllers[label]!.value == 1.0,
        onChanged: (bool? value) {
          setState(() {
            _controllers[label]!.value = value! ? 1.0 : 0.0;
          });
        },
      );
    }

    return [
      buildTextField('Name'),
      const SizedBox(height: 24),
      Text('Shirt Size', style: Theme.of(context).textTheme.titleLarge),
      buildTextField('Shirt length'),
      buildTextField('Shoulder'),
      buildTextField('Chest'),
      buildTextField('Waist'),
      buildTextField('Hip'),
      buildTextField('Daman'),
      buildTextField('Side'),
      buildTextField('Sleeves length'),
      buildTextField('Wrist'),
      buildTextField('Bicep'),
      buildTextField('Armhole'),
      buildCheckbox('Zip'),
      buildCheckbox('Pleats'),
      const SizedBox(height: 24),
      Text('Shalwar Size', style: Theme.of(context).textTheme.titleLarge),
      buildTextField('Shalwar length'),
      buildTextField('Paincha'),
      buildTextField('Belt'),
      buildTextField('Elastic'),
      const SizedBox(height: 24),
      Text('Trouser Size', style: Theme.of(context).textTheme.titleLarge),
      buildTextField('Trouser length'),
      buildTextField('Paincha'),
      buildTextField('Upper Thai'),
      buildTextField('Lower Thai Front'),
      buildTextField('Full Thai'),
      buildTextField('Asan Front'),
      buildTextField('Asan Back'),
      buildTextField('Lastic'),
      buildTextField('Type'),
    ];
  }

  Widget _buildValidationAlerts() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _validationAlerts.map((alert) {
          return Card(
            color: _getAlertColor(alert.level).withAlpha(25),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_getAlertIcon(alert.level), color: _getAlertColor(alert.level), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          alert.message,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getAlertColor(alert.level),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (alert.detailedExplanation != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(alert.detailedExplanation!),
                    ),
                  if (alert.correctiveAction != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Suggestion: ${alert.correctiveAction}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  if (alert.guideLink != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: InkWell(
                        onTap: () {
                          // Extract the measurement name from the guideLink
                          final measurementName = alert.guideLink!.split('/').last.replaceAll('how-to-measure-', '');
                          setState(() {
                            _selectedMeasurement = measurementName;
                          });
                        },
                        child: const Text(
                          'View Measurement Guide',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getAlertColor(AlertLevel level) {
    switch (level) {
      case AlertLevel.critical:
        return Colors.red;
      case AlertLevel.warning:
        return Colors.orange;
      case AlertLevel.info:
        return Colors.blue;
      case AlertLevel.success:
        return Colors.green;
    }
  }

  IconData _getAlertIcon(AlertLevel level) {
    switch (level) {
      case AlertLevel.critical:
        return Icons.error;
      case AlertLevel.warning:
        return Icons.warning;
      case AlertLevel.info:
        return Icons.info;
      case AlertLevel.success:
        return Icons.check_circle;
    }
  }

  void _saveMeasurement() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      
      // Show a snackbar to indicate that the measurement is being saved
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Saving...')),
      // );

      final session = ref.read(sessionProvider);
      final userId = session.whenOrNull(
        authenticated: (profile) => profile.userId,
      );

      if (userId != null) {
        final measurementRepository = ref.read(measurementRepositoryProvider);
        try {
          if (widget.measurement == null || widget.measurement!.id.isEmpty) {
            await measurementRepository.createMeasurement(
              _measurement,
            );
          } else {
            await measurementRepository
                .updateMeasurement(_measurement.id, _measurement.toJson());
          }
          ref.invalidate(measurementsProvider);
          await ref.read(measurementsProvider.future);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Measurement saved successfully')),
            );
            Navigator.of(context).pop();
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Failed to save measurement. Please try again.')),
            );
          }
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
