import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sartor_order_management/shared/components/order_card.dart';

class ImageUpload extends StatefulWidget {
  final Function(File?) onImageSelected;
  final AppContext appContext;
  final String? userRole;

  const ImageUpload({
    super.key,
    required this.onImageSelected,
    required this.appContext,
    this.userRole,
  });

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      // Validation
      final int fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) { // 5 MB
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image size should not exceed 5MB')),
          );
        }
        return;
      }
      
      final String fileExtension = pickedFile.path.split('.').last.toLowerCase();
      if (fileExtension != 'jpg' && fileExtension != 'jpeg' && fileExtension != 'png') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Only JPG, JPEG, and PNG files are allowed')),
          );
        }
        return;
      }

      setState(() {
        _image = imageFile;
      });
      widget.onImageSelected(_image);
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
    widget.onImageSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _image == null
              ? Center(
                  child: Text(
                    'No image selected.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        if (_image == null)
          if (widget.appContext == AppContext.client)
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Upload Actual Photo'),
            )
          else if (widget.appContext == AppContext.admin && widget.userRole == 'admin')
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Upload Photo for Admin'),
            )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.edit),
                label: const Text('Change'),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: _removeImage,
                icon: const Icon(Icons.delete),
                label: const Text('Remove'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
      ],
    );
  }
}
