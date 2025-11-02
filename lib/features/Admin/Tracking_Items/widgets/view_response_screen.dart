import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class ViewResponseScreen extends StatelessWidget {
  // Accepts the item model to display details and the associated response
  final PendingItemModel item;

  const ViewResponseScreen({super.key, required this.item});

  // --- Dummy Response Data (Simulating a response related to the item) ---
  final String _dummyResponseName = 'Juan Dela Cruz';
  final String _dummyResponseText = 
      'I saw a wallet matching this description (brown leather, slightly worn) left on a desk in the library study area on the date specified. I left it with the CAS security guard, Mr. Reyes. Please check there.';

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      appBar: AppBar(
        title: const Text('View Item Response'),
        backgroundColor: isDark ? CustomColors.darkBackground :CustomColors.lightBackground,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: Original Item Details (from the card) ---
            const Text(
              'Tracking Item Details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomColors.primary),
            ),
            const SizedBox(height: 16),
            
            // Item Card Snapshot (simplified display)
            _buildDetailSection(
              isDark, 
              title: item.title, 
              description: item.description, 
              date: item.date, 
              location: item.location
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),

            // --- Section 2: User/Admin Response ---
            const Text(
              'Associated Response',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomColors.primary),
            ),
            const SizedBox(height: 16),

            _buildResponseCard(isDark),

            const SizedBox(height: 32),

            // --- Section 3: Admin Action Buttons ---
            SizedBox(
              width:double.infinity,
              child: OutlinedButton.icon(
                onPressed: () { /* TODO: Contact Responder Logic */ },
                label: const Text('Accept Response'), 
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  // Helper widget to display the main item details
  Widget _buildDetailSection(
    bool isDark, {
    required String title,
    required String description,
    required String date,
    required String location,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? CustomColors.dark : CustomColors.lboxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.description, 'Description: $description', isDark),
          _buildInfoRow(Icons.calendar_today, 'Date: $date', isDark),
          _buildInfoRow(Icons.location_on, 'Location: $location', isDark),
        ],
      ),
    );
  }

  // Helper widget to display a single row of item info
  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: CustomColors.primary.withOpacity(0.7)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: isDark ? CustomColors.white : CustomColors.dark),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to display the response in a styled card
  Widget _buildResponseCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CustomColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CustomColors.info.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Responder: $_dummyResponseName',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.info),
              ),
            ],
          ),
          const Divider(height: 16),
          Text(
            _dummyResponseText,
            style: TextStyle(fontSize: 15, color: isDark ? CustomColors.white : CustomColors.dark),
          ),
        ],
      ),
    );
  }
}