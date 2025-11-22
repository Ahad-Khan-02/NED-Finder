import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportItemFormFields extends StatefulWidget {
  const ReportItemFormFields({super.key, required this.isLost});

  final bool isLost;

  @override
  State<ReportItemFormFields> createState() => _ReportItemFormFieldsState();
}

class _ReportItemFormFieldsState extends State<ReportItemFormFields> {
  String? _selectedCategory;
  File? _pickedImage;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> categories = [
    'Electronics',
    'Stationery',
    'Wallet/Purse',
    'ID/Documents',
    'Clothing',
    'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _pickedImage = File(image.path);
    });
  }

  Future<void> _submitReport() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');
    final String? email = prefs.getString('email');

    if (userId == null || email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
      return;
    }

    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill in all required fields and select an image.'),
        ),
      );
      return;
    }

    final Map<String, String> fields = {
      'user_id': userId.toString(),
      'item_type': widget.isLost ? 'lost' : 'found',
      'item_name': _nameController.text.trim(),
      'item_description': _descriptionController.text.trim(),
      'email': email,
      'location': _locationController.text.trim(),
    };

    setState(() {
      _isUploading = true;
    });

    try {
      print("📦 Sending fields: $fields");
      print("📸 Sending image: ${_pickedImage!.path}");

      // ✅ Make sure your Http.multipartPost uses MultipartFile.fromFile internally
      final response = await Http.multipartPost(
        'items/add',
        fields,
        _pickedImage!,
        'item_image',
      );

      print("🔁 Server response: $response");

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ??
                'Item submitted successfully, awaiting admin approval'),
          ),
        );

        // Clear fields
        _nameController.clear();
        _descriptionController.clear();
        _locationController.clear();
        _dateController.clear();
        setState(() {
          _pickedImage = null;
          _selectedCategory = null;
        });
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to submit item')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: _buildInputDecoration(
              CustomTexts.itemName, Icons.drive_file_rename_outline),
        ),
        const SizedBox(height: 20),

        DropdownButtonFormField<String>(
          decoration:
              _buildInputDecoration(CustomTexts.category, Icons.category),
          value: _selectedCategory,
          hint: const Text(CustomTexts.category),
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
        ),
        const SizedBox(height: 20),

        TextFormField(
          controller: _dateController,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: _buildInputDecoration(
            widget.isLost ? CustomTexts.dateLost : CustomTexts.dateFound,
            Icons.calendar_today,
          ),
        ),
        const SizedBox(height: 20),

        TextFormField(
          controller: _locationController,
          decoration: _buildInputDecoration(
              widget.isLost
                  ? CustomTexts.locationLostHint
                  : CustomTexts.locationFoundHint,
              Icons.location_on),
        ),
        const SizedBox(height: 20),

        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: _buildInputDecoration(
            CustomTexts.description,
            Icons.description,
          ).copyWith(
            contentPadding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
          ),
        ),
        const SizedBox(height: 20),

        OutlinedButton.icon(
          onPressed: _uploadImage,
          icon: _pickedImage != null
              ? const Icon(Icons.check_circle_outline, color: Colors.green)
              : const Icon(Icons.cloud_upload),
          label: Text(
            _pickedImage != null
                ? 'Image Selected: ${Uri.file(_pickedImage!.path).pathSegments.last}'
                : 'Upload Image',
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: _pickedImage != null
                ? const BorderSide(color: Colors.green, width: 2)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),

        if (_pickedImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _pickedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isUploading ? null : _submitReport,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _isUploading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(CustomTexts.submit),
          ),
        ),
      ],
    );
  }
}
