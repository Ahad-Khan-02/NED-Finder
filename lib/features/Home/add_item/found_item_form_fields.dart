import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';

class FoundItemFormFields extends StatefulWidget {
  const FoundItemFormFields({super.key});

  @override
  State<FoundItemFormFields> createState() => _FoundItemFormFieldsState();
}

class _FoundItemFormFieldsState extends State<FoundItemFormFields> {
  // --- State Variables ---
  String? _selectedCategory;
  final TextEditingController _dateController = TextEditingController();
  
  // Example categories (same as lost item screen)
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
  void _uploadImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker launched! (Placeholder)')),
    );
  }

  // --- Input Decoration Style (Reused for all fields) ---
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: CustomColors.primaryBlue),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: CustomColors.primaryBlue, width: 2.0),
      ),
      // Set contentPadding to align text to the top for multi-line fields
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Item Name
        TextFormField(
          decoration: _buildInputDecoration('Item Name', Icons.drive_file_rename_outline),
        ),
        const SizedBox(height: 20),

        // 2. Category Dropdown
        DropdownButtonFormField<String>(
          decoration: _buildInputDecoration('Category', Icons.category),
          value: _selectedCategory,
          hint: const Text('Select Category'),
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

        // 3. Date Found
        TextFormField(
          controller: _dateController,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: _buildInputDecoration('Date Found', Icons.calendar_today),
        ),
        const SizedBox(height: 20),

        // 4. Location Found
        TextFormField(
          decoration: _buildInputDecoration('Location Found (e.g., Building A, Cafeteria)', Icons.location_on),
        ),
        const SizedBox(height: 20),

        // 5. Description (Multi-line field with corrected padding)
        TextFormField(
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          // contentPadding in the decoration helper handles vertical alignment
          decoration: _buildInputDecoration('Description of Item', Icons.description), 
        ),
        const SizedBox(height: 20),

        // 6. Upload Image Button
        OutlinedButton.icon(
          onPressed: _uploadImage,
          icon: const Icon(Icons.cloud_upload),
          label: const Text('Upload Image'), // Image is usually required for found items
          style: OutlinedButton.styleFrom(
            foregroundColor: CustomColors.primaryBlue,
            side: const BorderSide(color: CustomColors.primaryBlue),
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