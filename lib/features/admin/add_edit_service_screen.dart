import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

class AddEditServiceScreen extends ConsumerStatefulWidget {
  final Service? service;

  const AddEditServiceScreen({super.key, this.service});

  @override
  ConsumerState<AddEditServiceScreen> createState() =>
      _AddEditServiceScreenState();
}

class _AddEditServiceScreenState extends ConsumerState<AddEditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  late ServiceCategory _category;
  late String _imageUrl;
  late bool _isActive;
  File? _imageFile;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _name = widget.service?.name ?? '';
    _description = widget.service?.description ?? '';
    _price = widget.service?.price ?? 0.0;
    _category = widget.service?.category ?? ServiceCategory.womensWear;
    _imageUrl = widget.service?.imageUrl ?? '';
    _isActive = widget.service?.isActive ?? true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateForm());
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      final fileType = pickedFile.path.split('.').last.toLowerCase();
      const allowedTypes = ['jpg', 'jpeg', 'png'];

      if (!allowedTypes.contains(fileType)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid file type. Please select a JPG or PNG image.')),
        );
        return;
      }

      if (fileSize > 2 * 1024 * 1024) { // 2MB limit
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File size exceeds 2MB limit.')),
        );
        return;
      }

      setState(() {
        _imageFile = file;
      });
    }
  }

  void _saveService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Show progress indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      String imageUrl = _imageUrl;
      if (_imageFile != null) {
        try {
          // This is a placeholder for your actual image upload logic
          // imageUrl = await ref.read(serviceRepositoryProvider).uploadServiceImage(_imageFile!);
          // For now, we'll just use a placeholder string
          imageUrl = 'https://via.placeholder.com/150';
        } catch (e) {
          Navigator.of(context).pop(); // dismiss progress indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image upload failed: $e')),
          );
          return;
        }
      }
      Navigator.of(context).pop(); // dismiss progress indicator

      final service = Service(
        id: widget.service?.id ?? 0,
        name: _name,
        description: _description,
        price: _price,
        category: _category,
        imageUrl: imageUrl,
        isActive: _isActive,
      );

      try {
        if (widget.service == null) {
          await ref.read(serviceRepositoryProvider).addService(service);
        } else {
          await ref.read(serviceRepositoryProvider).updateService(service);
        }
        ref.invalidate(allServicesProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service saved successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save service: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service == null ? 'Add Service' : 'Edit Service'),
        actions: [
          if (widget.service != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref
                    .read(serviceRepositoryProvider)
                    .deleteService(widget.service!.id);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
      body: ResponsiveLayout(
        mobileBody: _buildMobileLayout(),
        tabletBody: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        onChanged: _validateForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          children: _buildFormFields(),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        onChanged: _validateForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  _buildImagePicker(),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('Is Active'),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    key: const Key('save_service_button'),
                    onPressed: _isFormValid ? _saveService : null,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormFields({bool isTablet = false}) {
    return [
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
        value: _category,
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
        _buildImagePicker(),
        SwitchListTile(
          title: const Text('Is Active'),
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          key: const Key('save_service_button'),
          onPressed: _isFormValid ? _saveService : null,
          child: const Text('Save'),
        ),
      ],
    ];
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_imageFile != null)
          Image.file(_imageFile!, height: 150)
        else if (_imageUrl.isNotEmpty)
          Image.network(_imageUrl, height: 150),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('Select Image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
