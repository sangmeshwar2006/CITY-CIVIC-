import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/complaint_service.dart';
import '../services/location_service.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationService = LocationService();
  final _picker = ImagePicker();

  String _category = 'Garbage';
  File? _selectedImage;
  bool _loading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 75);
    if (picked == null) return;
    setState(() => _selectedImage = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final location = await _locationService.getCurrentLocation();
      final token = context.read<AuthService>().token!;

      await context.read<ComplaintService>().createComplaint(
            token: token,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            category: _category,
            lat: location['lat'] as double,
            lng: location['lng'] as double,
            address: location['address'] as String,
            imageFile: _selectedImage,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const categories = ['Garbage', 'Road', 'Water', 'Electricity', 'Other'];

    return Scaffold(
      appBar: AppBar(title: const Text('Add Complaint')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Title',
                validator: (value) => Validators.requiredField(value, 'Title'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 5,
                validator: (value) =>
                    Validators.requiredField(value, 'Description'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _category = value ?? 'Other'),
              ),
              const SizedBox(height: 16),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD7E3EF)),
                ),
                child: _selectedImage == null
                    ? const Center(child: Text('No image selected'))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Gallery'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Camera'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: Text(_loading ? 'Submitting...' : 'Submit Complaint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
