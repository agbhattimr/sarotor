import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/providers/measurement_template_provider.dart';
import 'package:uuid/uuid.dart';

class AddEditTemplateDialog extends ConsumerStatefulWidget {
  final MeasurementTemplate? template;

  const AddEditTemplateDialog({super.key, this.template});

  @override
  ConsumerState<AddEditTemplateDialog> createState() => _AddEditTemplateDialogState();
}

class _AddEditTemplateDialogState extends ConsumerState<AddEditTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late Map<String, double> _measurements;

  @override
  void initState() {
    super.initState();
    _name = widget.template?.name ?? '';
    _description = widget.template?.description ?? '';
    _measurements = widget.template?.standardMeasurements.cast<String, double>() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.template == null ? 'Add Template' : 'Edit Template'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
            ),
            Expanded(
              child: ListView(
                children: [
                  ..._buildMeasurementTextFields(),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final repository = ref.read(measurementTemplateRepositoryProvider);
              if (widget.template == null) {
                final newTemplate = MeasurementTemplate(
                  id: const Uuid().v4(),
                  name: _name,
                  description: _description,
                  standardMeasurements: _measurements,
                  measurementRanges: {}, // Add default value
                  category: '', // Add default value
                );
                repository.addMeasurementTemplate(newTemplate);
              } else {
                final updatedTemplate = widget.template!.copyWith(
                  name: _name,
                  description: _description,
                  standardMeasurements: _measurements,
                );
                repository.updateMeasurementTemplate(updatedTemplate);
              }
              ref.read(measurementTemplatesProvider.notifier).refresh();
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  List<Widget> _buildMeasurementTextFields() {
    final measurementFields = [
      'shirtLength', 'shoulder', 'chest', 'waist', 'hip', 'daman',
      'side', 'sleevesLength', 'wrist', 'bicep', 'armhole',
      'shalwarLength', 'paincha', 'ghair', 'belt', 'lastic',
      'trouserLength', 'painchaTrouser', 'upperThai', 'lowerThaiFront',
      'fullThai', 'asanFront', 'asanBack', 'lasticTrouser'
    ];

    return measurementFields.map((field) {
      return TextFormField(
        initialValue: _measurements[field]?.toString(),
        decoration: InputDecoration(labelText: field),
        keyboardType: TextInputType.number,
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            _measurements[field] = double.parse(value);
          }
        },
      );
    }).toList();
  }
}
