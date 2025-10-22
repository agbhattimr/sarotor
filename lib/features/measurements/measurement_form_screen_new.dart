import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';
import 'package:sartor_order_management/features/measurements/widgets/measurement_input_widget.dart';

class MeasurementFormScreenNew extends ConsumerStatefulWidget {
  final Measurement? measurement;

  const MeasurementFormScreenNew({super.key, this.measurement});

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

  @override
  void initState() {
    super.initState();
    _measurement = widget.measurement ??
        const Measurement(
          id: '',
          userId: '',
          profileName: '',
        );

    _measurement.measurements.forEach((key, value) {
      _controllers[key] = MeasurementController(
        initialValue: value,
        onChanged: (newValue) {
          final newMeasurements =
              Map<String, double?>.from(_measurement.measurements);
          newMeasurements[key] = newValue;
          _measurement = _measurement.copyWithMeasurements(newMeasurements);
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
          IconButton(
            onPressed: _isLoading ? null : _saveMeasurement,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ResponsiveLayout(
                mobileBody: _buildMobileLayout(),
                tabletBody: _buildTabletLayout(),
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
    final fields = _buildFormFields();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: fields.sublist(0, (fields.length / 2).ceil()),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: fields.sublist((fields.length / 2).ceil()),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      TextFormField(
        initialValue: _measurement.profileName,
        decoration: const InputDecoration(labelText: 'Profile Name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a profile name';
          }
          return null;
        },
        onSaved: (value) {
          _measurement = _measurement.copyWith(profileName: value!);
        },
      ),
      const SizedBox(height: 16),
      ..._buildMeasurementInputFields(),
      const SizedBox(height: 16),
      TextFormField(
        initialValue: _measurement.notes,
        decoration: const InputDecoration(labelText: 'Notes'),
        onSaved: (value) {
          _measurement = _measurement.copyWith(notes: value);
        },
      ),
    ];
  }

  List<Widget> _buildMeasurementInputFields() {
    return _controllers.entries.map<Widget>((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: MeasurementInputWidget(
          label: entry.key,
          controller: entry.value,
        ),
      );
    }).toList();
  }

  void _saveMeasurement() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final session = ref.read(sessionProvider);
      final userId = session.whenOrNull(
        authenticated: (profile) => profile.userId,
      );

      if (userId != null) {
        final measurementRepository = ref.read(measurementRepositoryProvider);
        try {
          if (widget.measurement == null || widget.measurement!.id.isEmpty) {
            await measurementRepository.createMeasurement(
              _measurement.copyWith(userId: userId),
            );
          } else {
            await measurementRepository
                .updateMeasurement(_measurement.id, _measurement.toSupabase());
          }
          ref.refresh(measurementsProvider);
          if (mounted) {
            Navigator.of(context).pop();
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving measurement: $e')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
