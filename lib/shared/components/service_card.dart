import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/shared/components/order_card.dart';

class ServiceCard extends ConsumerStatefulWidget {
  final Service service;
  final AppContext appContext;
  final String? userRole;

  const ServiceCard({
    super.key,
    required this.service,
    required this.appContext,
    this.userRole,
  });

  @override
  ConsumerState<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends ConsumerState<ServiceCard> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  File? _actualImage;
  File? _referenceImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.service.name);
    _descriptionController =
        TextEditingController(text: widget.service.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source,
      {required bool isActual}) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isActual) {
          _actualImage = File(pickedFile.path);
        } else {
          _referenceImage = File(pickedFile.path);
        }
      });
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _save() {
    final updatedService = widget.service.copyWith(
      name: _titleController.text,
      description: _descriptionController.text,
      // In a real app, you'd handle image URL updates after uploading
    );

    ref.read(cartProvider.notifier).updateService(updatedService);

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service updated.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isEditing ? _buildEditMode() : _buildViewMode();
  }

  Widget _buildViewMode() {
    final cartNotifier = ref.read(cartProvider.notifier);
    final serviceCount = ref.watch(cartProvider.select(
      (cart) => cartNotifier.getServiceCount(widget.service.id),
    ));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: Colors.grey[200],
                  child: _actualImage != null
                      ? Image.file(_actualImage!, fit: BoxFit.cover)
                      : (widget.service.imageUrl != null
                          ? Image.network(
                              widget.service.imageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.style,
                              size: 48,
                              color: Colors.grey[400],
                            )),
                ),
                if (widget.appContext == AppContext.admin && widget.userRole == 'admin')
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _toggleEdit,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(178),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleController.text,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'PKR ${widget.service.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          if (widget.appContext == AppContext.client)
            _buildQuantityControls(serviceCount),
        ],
      ),
    );
  }

  Widget _buildEditMode() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildImagePicker(
              label: 'Actual Image',
              image: _actualImage,
              onPick: (source) => _pickImage(source, isActual: true),
            ),
            const SizedBox(height: 16),
            _buildImagePicker(
              label: 'Reference Image',
              image: _referenceImage,
              onPick: (source) => _pickImage(source, isActual: false),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _toggleEdit,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required File? image,
    required Function(ImageSource) onPick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: image != null
              ? Image.file(image, fit: BoxFit.cover)
              : const Center(child: Text('No Image Selected')),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => onPick(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => onPick(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityControls(int serviceCount) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: serviceCount > 0 ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => ref.read(cartProvider.notifier).addService(widget.service),
            icon: Icon(
              serviceCount > 0 ? Icons.add : Icons.add_circle_outline,
              color: serviceCount > 0 ? Colors.green : Theme.of(context).colorScheme.primary,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 40),
            child: Text(
              '$serviceCount',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: serviceCount > 0 ? Colors.green : Colors.grey,
              ),
            ),
          ),
          IconButton(
            onPressed: serviceCount > 0
                ? () => ref.read(cartProvider.notifier).removeService(widget.service.id)
                : null,
            icon: Icon(
              Icons.remove,
              color: serviceCount > 0 ? Colors.red : Colors.grey,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
