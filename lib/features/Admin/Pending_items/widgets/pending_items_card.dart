import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; // Import Http client

class AdminPendingItemCard extends StatelessWidget {
  const AdminPendingItemCard({
    super.key,
    required this.item,
    required this.onUpdate, // 1. ADDED: Callback for list update
  });

  final PendingItemModel item;
  final VoidCallback onUpdate; // 2. ADDED: VoidCallback property

  // --- API CALL: APPROVE ITEM ---
  Future<void> _approveItem(BuildContext context) async {
    try {
      final responseData = await Http.post('items/approve/${item.id}', {}); // POST request with empty body
      
      if (responseData['status'] == 'success') {
        // Display success message (Using a simple SnackBar as a placeholder)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item approved successfully!')),
        );
        onUpdate(); // Trigger parent widget to refresh list
      } else {
        throw Exception(responseData['message'] ?? 'Failed to approve item.');
      }
    } catch (e) {
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving item: ${e.toString()}')),
      );
      debugPrint('Approval Error: ${e.toString()}');
    }
  }

  // --- API CALL: REJECT/DELETE ITEM ---
  Future<void> _rejectItem(BuildContext context) async {
    try {
      // Assuming 'Delete' action maps to the 'reject' endpoint
      final responseData = await Http.post('items/reject/${item.id}', {}); // POST request with empty body
      
      if (responseData['status'] == 'success') {
        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item rejected (deleted) successfully!')),
        );
        onUpdate(); // Trigger parent widget to refresh list
      } else {
        throw Exception(responseData['message'] ?? 'Failed to reject item.');
      }
    } catch (e) {
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting item: ${e.toString()}')),
      );
      debugPrint('Rejection Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final bool hasImage = item.imageBytes.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? CustomColors.dark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Display (Fixed Height: 200)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              color: hasImage ? null : Colors.grey.shade300,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: hasImage
                  ? Image.memory(
                      item.imageBytes,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.broken_image, color: Colors.blueGrey.shade400)),
                    )
                  : Center(
                      child: Icon(Icons.image_not_supported,
                          color: Colors.blueGrey.shade400, size: 40),
                    ),
            ),
          ),

          // 2. Details (Expanded to fill remaining space)
          Expanded( // Correctly wraps the Padding/details area
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  // --- Details Content (Wrapped in Expanded/Scrollable for the overflow fix) ---
                  Expanded( 
                    child: SingleChildScrollView( // Allows scrolling if text is too long
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item Type Tag (Lost/Found)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.itemType == 'lost' ? CustomColors.error.withOpacity(0.1) : CustomColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              item.itemType.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: item.itemType == 'lost' ? CustomColors.error : CustomColors.success,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Title (item_name)
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Submitter
                          _buildDetailRow(
                            Icons.person,
                            item.submitterName,
                            isSubtitle: true,
                          ),
                          const SizedBox(height: 8),

                          // Description
                          _buildDetailRow(
                            Icons.description,
                            item.description,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),

                          // Date and Time
                          _buildDetailRow(
                            Icons.calendar_today,
                            '${item.dateString} at ${item.timeString}',
                          ),
                          const SizedBox(height: 8),

                          // Location
                          _buildDetailRow(
                            Icons.location_on,
                            item.location,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),

                  // 3. Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          // 3. UPDATED: Call the approval method
                          onPressed: () => _approveItem(context), 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Approve'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          // 4. UPDATED: Call the rejection method
                          onPressed: () => _rejectItem(context), 
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red.shade100,
                            foregroundColor: CustomColors.error,
                            side: const BorderSide(color: CustomColors.error),
                          ),
                          child: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for standardized detail rows (kept unchanged)
  Widget _buildDetailRow(IconData icon, String text, {int maxLines = 1, bool isSubtitle = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: isSubtitle ? 14 : 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSubtitle ? 12 : 14,
              fontStyle: isSubtitle ? FontStyle.italic : FontStyle.normal,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}