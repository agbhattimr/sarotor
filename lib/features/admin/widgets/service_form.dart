import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

class ServiceForm extends ConsumerStatefulWidget {
  final Service? service;
  final Function(Service) onSave;

  const ServiceForm({super.key, this.service, required this.onSave});

  @override
  ConsumerState<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends ConsumerState<ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  late ServiceCategory _category;
  late bool _isActive;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _name = widget.service?.name ?? '';
    _description = widget.service?.description ?? '';
    _price = widget.service?.price ?? 0.0;
    _category = widget.service?.category ?? ServiceCategory.womensWear;
    _isActive = widget.service?.isActive ?? true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateForm());
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form.')),
      );
      return;
    }
    _formKey.currentState!.save();

    final service = Service(
      id: widget.service?.id ?? 0,
      name: _name,
      description: _description,
      price: _price,
      category: _category,
      isActive: _isActive,
    );

    widget.onSave(service);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _validateForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ResponsiveLayout(
        mobileBody: _buildMobileLayout(),
        tabletBody: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: _buildFormFields(),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ListView(
              children: _buildFormFields(isTablet: true),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Is Active'),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  key: const Key('save_service_button'),
                  onPressed: _isFormValid ? _save : null,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields({bool isTablet = false}) {
    return [
      if (widget.service != null)
        TextFormField(
          initialValue: widget.service!.id.toString(),
          decoration: const InputDecoration(labelText: 'Service ID'),
          readOnly: true,
        ),
      TextFormField(
        key: const Key('service_name_field'),
        initialValue: _name,
        decoration: const InputDecoration(labelText: 'Name'),
        validator: (value) =>
            value!.isEmpty ? 'Please enter a name' : null,
        onSaved: (value) => _name = value!,
      ),
      TextFormField(
        key: const Key('service_description_field'),
        initialValue: _description,
        decoration: const InputDecoration(labelText: 'Description'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a description';
          }
          if (value.length < 10) {
            return 'Description must be at least 10 characters long';
          }
          return null;
        },
        onSaved: (value) => _description = value!,
      ),
      TextFormField(
        key: const Key('service_price_field'),
        initialValue: _price.toString(),
        decoration: const InputDecoration(labelText: 'Price'),
        keyboardType: TextInputType.number,
        validator: (value) =>
            value!.isEmpty ? 'Please enter a price' : null,
        onSaved: (value) => _price = double.parse(value!),
      ),
      DropdownButtonFormField<ServiceCategory>(
        initialValue: _category,
        items: ServiceCategory.values
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                ))
            .toList(),
        onChanged: (value) => setState(() => _category = value!),
        decoration: const InputDecoration(labelText: 'Category'),
      ),
      if (!isTablet) ...[
        const SizedBox(height: 20),
        SwitchListTile(
          title: const Text('Is Active'),
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          key: const Key('save_service_button'),
          onPressed: _isFormValid ? _save : null,
          child: const Text('Save'),
        ),
      ],
    ];
  }
}
