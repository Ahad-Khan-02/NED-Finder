import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ned_finder/utils/constants/texts.dart';


class ReportItemFormFields extends StatefulWidget {
  

  const ReportItemFormFields({
    super.key,
    required this.isLost
  });
  
  final bool isLost;
  

  @override
  State<ReportItemFormFields> createState() => _ReportItemFormFieldsState();
}

class _ReportItemFormFieldsState extends State<ReportItemFormFields> {
  // --- State Variables ---
  String? _selectedCategory;
  
  final TextEditingController _dateController = TextEditingController();
  
  // Example categories (Define these in CustomTexts or an enum in a real app)
  final List<String> categories = [
    'Electronics',
    'Stationery',
    'Wallet/Purse',
    'ID/Documents',
    'Clothing',
    'Other'
  ];

  // --- Date Picker Function ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // --- Image Upload Placeholder ---
  File? _pickedImage; 
  String? _uploadedImageUrl;
  bool _isUploading = false;
  
  // Instance of the Image Picker
  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadImage() async {
    // 1. PICK IMAGE
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      // User canceled the selection
      return; 
    }

    // Update state to show the user which image was picked
    setState(() {
      _pickedImage = File(image.path);
      _isUploading = true;
      _uploadedImageUrl = null; // Reset URL while uploading
    });

  //   try {
  //     // 2. UPLOAD TO FIREBASE STORAGE
  //     // Create a unique path in Firebase Storage (e.g., 'images/timestamp.jpg')
  //     String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     Reference storageRef = FirebaseStorage.instance.ref().child('product_images/$fileName');

  //     // Upload the file
  //     UploadTask uploadTask = storageRef.putFile(_pickedImage!);

  //     // Wait for the upload to complete and get the download URL
  //     TaskSnapshot snapshot = await uploadTask;
  //     String downloadUrl = await snapshot.ref.getDownloadURL();

  //     // 3. SUCCESS & STATE UPDATE
  //     setState(() {
  //       _uploadedImageUrl = downloadUrl;
  //       _isUploading = false;
  //       // Optionally, clear _pickedImage if you only need the URL
  //       // _pickedImage = null; 
  //     });

  //     // Show a success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Image uploaded successfully!')),
  //     );

  //     print('Uploaded Image URL: $downloadUrl');

  //   } on FirebaseException catch (e) {
  //     // Handle Firebase specific errors
  //     setState(() {
  //       _isUploading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Upload failed: ${e.message}')),
  //     );
  //   } catch (e) {
  //     // Handle other errors (e.g., IO errors, permissions)
  //     setState(() {
  //       _isUploading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An unexpected error occurred.')),
  //     );
  //   }
  }

  // --- Input Decoration Style (Reused for all fields) ---
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
    );
  }

  

 
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // 1. Item Name
        TextFormField(
          decoration: _buildInputDecoration(CustomTexts.itemName, Icons.drive_file_rename_outline),
        ),
        const SizedBox(height: 20),

        // 2. Category Dropdown
        DropdownButtonFormField<String>(
          decoration: _buildInputDecoration(CustomTexts.category, Icons.category),
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

        // 3. Date Lost
        TextFormField(
          controller: _dateController,
          readOnly: true, // Prevents manual input, forces date picker usage
          onTap: () => _selectDate(context),
          decoration: _buildInputDecoration(widget.isLost? CustomTexts.dateLost : CustomTexts.dateFound, Icons.calendar_today),
        ),
        const SizedBox(height: 20),

        // 4. Location Lost
        TextFormField(
          decoration: _buildInputDecoration(widget.isLost? CustomTexts.locationLostHint : CustomTexts.locationFoundHint, Icons.location_on),
        ),
        const SizedBox(height: 20),

        // 5. Description
        TextFormField(
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: _buildInputDecoration(CustomTexts.description, Icons.description).copyWith(
            // Override contentPadding to align the text to the top for the multi-line field.
            // The prefixIcon will now align itself vertically near the top of the box.
            contentPadding: const EdgeInsets.fromLTRB(10, 16, 10, 10), 
          ),
        ),
        const SizedBox(height: 20),

        // 6. Upload Image Button
        OutlinedButton.icon(
          onPressed: _uploadImage,
          icon: const Icon(Icons.cloud_upload),
          label: const Text('Upload Image (Optional)'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}