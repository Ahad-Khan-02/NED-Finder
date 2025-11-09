import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/http/http_client.dart'; // Ensure this is implemented correctly!


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
 File? _pickedImage; // Stores the local image file for submission
 
 // Boolean to control the loading state of the submit button
 bool _isUploading = false; 
 
 final ImagePicker _picker = ImagePicker();

 // --- Text Controllers for all fields ---
 final TextEditingController _nameController = TextEditingController();
 final TextEditingController _dateController = TextEditingController();
 final TextEditingController _locationController = TextEditingController();
 final TextEditingController _descriptionController = TextEditingController();
 
 
 // Example categories (Define these in CustomTexts or an enum in a real app)
 final List<String> categories = [
  'Electronics',
  'Stationery',
  'Wallet/Purse',
  'ID/Documents',
  'Clothing',
  'Other'
 ];
 
 // --- Cleanup Controllers ---
 @override
 void dispose() {
  _nameController.dispose();
  _dateController.dispose();
  _locationController.dispose();
  _descriptionController.dispose();
  super.dispose();
 }


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


 // --- Image Picker Function ---
 Future<void> _uploadImage() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image == null) {
   return; 
  }

  setState(() {
   // Store the picked file and trigger UI update
   _pickedImage = File(image.path);
  });
 }

 // --- Form Submission Function ---
 Future<void> _submitReport() async {
  // Example: Basic validation
  if (_nameController.text.isEmpty || _locationController.text.isEmpty || _dateController.text.isEmpty) {
   ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please fill in required fields (Name, Date, Location).')),
   );
   return;
  }
  
  // NOTE: Replace these dummy values with actual user session data!
  const int dummyUserId = 1; 
  const String dummyEmail = 'test@example.com'; 
  
  final Map<String, String> fields = {
   'user_id': dummyUserId.toString(),
   'item_name': _nameController.text,
   'item_description': _descriptionController.text,
   'email': dummyEmail, 
   'location': _locationController.text,
   'date': _dateController.text,
   // 'category': _selectedCategory ?? 'Other', // Include if needed by FastAPI
   // Add 'found' status if your FastAPI needs it explicitly:
   // 'found': widget.isLost ? 'false' : 'true',
  };


  try {
   setState(() {
    _isUploading = true; // Start loading indicator
   });
   
   // Call the new multipartPost helper in your Http class
   final response = await Http.multipartPost(
    'items/add', // FastAPI endpoint
    fields,
    _pickedImage, 
    'item_image', // FastAPI's required field name for the file
   );

   // Handle response
   if (response['status'] == 'success') {
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(content: Text('Item reported successfully!')),
    );
    // TODO: Clear form or navigate back
   } else {
    throw Exception(response['message'] ?? 'Failed to report item. Status: ${response['status']}');
   }

  } catch (e) {
   print('🚨 Submission Error: $e');
   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Submission failed: ${e.toString()}')),
   );
  } finally {
   setState(() {
    _isUploading = false; // Stop loading indicator
   });
  }
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
     controller: _nameController,
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

    // 3. Date Lost/Found
    TextFormField(
     controller: _dateController,
     readOnly: true, 
     onTap: () => _selectDate(context),
     decoration: _buildInputDecoration(widget.isLost? CustomTexts.dateLost : CustomTexts.dateFound, Icons.calendar_today),
    ),
    const SizedBox(height: 20),

    // 4. Location Lost/Found
    TextFormField(
     controller: _locationController,
     decoration: _buildInputDecoration(widget.isLost? CustomTexts.locationLostHint : CustomTexts.locationFoundHint, Icons.location_on),
    ),
    const SizedBox(height: 20),

    // 5. Description
    TextFormField(
     controller: _descriptionController,
     maxLines: 4,
     keyboardType: TextInputType.multiline,
     decoration: _buildInputDecoration(CustomTexts.description, Icons.description).copyWith(
      contentPadding: const EdgeInsets.fromLTRB(10, 16, 10, 10), 
     ),
    ),
    const SizedBox(height: 20),

    // 6. Upload Image Button and Preview
    OutlinedButton.icon(
     onPressed: _uploadImage,
     // Conditional Icon and Label
     icon: _pickedImage != null 
      ? const Icon(Icons.check_circle_outline, color: Colors.green) 
      : const Icon(Icons.cloud_upload), 
     label: Text(
      _pickedImage != null 
       ? 'Image Selected: ${Uri.file(_pickedImage!.path).pathSegments.last}'
       : 'Upload Image (Optional)',
     ),
     style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      // Conditional Border Color
      side: _pickedImage != null ? const BorderSide(color: Colors.green, width: 2) : null, 
      shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(10.0),
      ),
     ),
    ),

    // Image Thumbnail Preview
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


    // Submit Button
    const SizedBox(height: 30),
    SizedBox(
     width: double.infinity,
     child: ElevatedButton(
      // Disable button when uploading
      onPressed: _isUploading ? null : _submitReport, 
      
      // Conditional child for loading indicator
      child: _isUploading
        ? const SizedBox(
          height: 20, 
          width: 20,
          child: CircularProgressIndicator(
           color: Colors.white, 
           strokeWidth: 3,
          ),
         )
        : const Text(
          CustomTexts.submit,
         ),
     ),
    ),
   ],
  );
 }
}