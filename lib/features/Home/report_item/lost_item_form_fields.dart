import 'package:flutter/material.dart';


class LostItemFormFields extends StatefulWidget {
  const LostItemFormFields({super.key});

  @override
  State<LostItemFormFields> createState() => _LostItemFormFieldsState();
}

class _LostItemFormFieldsState extends State<LostItemFormFields> {
  // --- State Variables ---
  String? _selectedCategory;
  TextEditingController _dateController = TextEditingController();
  
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
  void _uploadImage() {
    // TODO: Implement image picker logic (using package like image_picker)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker launched! (Placeholder)')),
    );
  }

  // --- Input Decoration Style (Reused for all fields) ---
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      ),
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

        // 3. Date Lost
        TextFormField(
          controller: _dateController,
          readOnly: true, // Prevents manual input, forces date picker usage
          onTap: () => _selectDate(context),
          decoration: _buildInputDecoration('Date Lost', Icons.calendar_today),
        ),
        const SizedBox(height: 20),

        // 4. Location Lost
        TextFormField(
          decoration: _buildInputDecoration('Location Lost (e.g., Library, Room B101)', Icons.location_on),
        ),
        const SizedBox(height: 20),

        // 5. Description
        TextFormField(
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: _buildInputDecoration('Description', Icons.description).copyWith(
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
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
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