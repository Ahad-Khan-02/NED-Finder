import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Required for date formatting
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class ViewItemScreen extends StatelessWidget {
  // Pass the item data to the screen
  final ItemModel item;
  
  const ViewItemScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isDark  = HelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDark? CustomColors.darkBackground :CustomColors.lightBackground,
      // No app bar, as the image shows a full-screen image at the top
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Item Image Section
            _buildImageSection(context),

            // 2. Item Details (White Card Area)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Name (Header)
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category & Status Row
                  _buildDetailRow(
                    icon: Icons.category,
                    label: 'Category',
                    value: item.category,
                    isDark: isDark
                  ),
                  const SizedBox(height: 10),
                  
                  // Status Tag (Found/Missing)
                  _buildStatusTag(),
                  const SizedBox(height: 20),


                  // Description
                  _buildDetailSection(
                    icon: Icons.description,
                    label: 'Description',
                    value: item.description,
                    isDark:isDark
                  ),
                  const SizedBox(height: 20),

                  // Date Found/Lost
                  _buildDetailSection(
                    icon: Icons.calendar_today,
                    label: item.dateLabel,
                    value: DateFormat('yyyy-MM-dd').format(item.date),
                    isDark: isDark
                  ),
                  const SizedBox(height: 20),

                  // Location Found/Lost
                  _buildDetailSection(
                    icon: Icons.location_on,
                    label: item.locationLabel,
                    value: item.location,
                    isDark: isDark
                  ),
                  const SizedBox(height: 30),

                  // Action Buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildImageSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4, // Takes 40% of screen height
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Placeholder background
        image: DecorationImage(
          // Use Image.network or Image.asset here. Using a hardcoded asset path for simplicity.
          image: AssetImage(item.imageUrl), 
          fit: BoxFit.cover,
        ),
      ),
      // Ensures the image area is pushed down from the top edge (status bar)
      child: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: item.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: item.statusColor),
      ),
      child: Text(
        item.statusText,
        style: TextStyle(
          color: item.statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color:isDark? Colors.white : Colors.black, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        // Value below the icon/label for better readability
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 4),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
  
  // Custom builder for description and longer text fields
  Widget _buildDetailSection({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color:isDark? Colors.white : Colors.black87, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Claim This Item Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement claim logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Claim initiated!')),
              );
            },
            
            child: const Text(
              'Claim This Item',
            ),
          ),
        ),
        const SizedBox(height: 15),

        // Close Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            
            child: Text(
              'Close',
            ),
          ),
        ),
      ],
    );
  }
}

// --- Example Usage ---

/*
void main() {
  // Example data for a found item (similar to the image)
  final exampleFoundItem = ItemModel(
    id: '123',
    name: 'Leather Wallet',
    category: 'Wallet/Purse',
    date: DateTime(2024, 6, 15),
    location: 'CAS - ROOM 404',
    description: 'This is for testing for found item. It is made of brown leather with a snake-skin pattern and has four card slots inside.',
    imageUrl: 'assets/images/wallet.jpg', // MUST be a valid asset path
    status: ItemStatus.found,
  );

  // Example data for a missing item (similar to the ID Lace in the home screen)
  final exampleMissingItem = ItemModel(
    id: '456',
    name: 'QLFU ID Lace',
    category: 'ID/Documents',
    date: DateTime(2024, 10, 1),
    location: 'Library Entrance',
    description: 'QLFU ID Lace, green and black silk linen. The card attached is an employee ID for the Engineering department.',
    imageUrl: 'assets/images/id_lace.jpg', // MUST be a valid asset path
    status: ItemStatus.missing,
  );

  runApp(
    MaterialApp(
      title: 'Item Details',
      home: ViewItemScreen(item: exampleFoundItem),
      debugShowCheckedModeBanner: false,
    ),
  );
}
*/