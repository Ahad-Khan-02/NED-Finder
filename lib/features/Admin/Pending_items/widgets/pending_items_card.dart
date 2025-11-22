import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart';
import 'package:ned_finder/features/Admin/Pending_items/widgets/pending_items_card_details.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
// Import the new details screen

class AdminPendingItemCard extends StatelessWidget {
  const AdminPendingItemCard({
    super.key,
    required this.item,
    required this.onUpdate, // Callback for list update
  });

  final PendingItemModel item;
  final VoidCallback onUpdate;

  // Function to handle the navigation when the card is tapped
  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminItemDetailsScreen(
          item: item,
          onUpdate: onUpdate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final bool hasImage = item.imageBytes.isNotEmpty;

    // Wrap the card content in InkWell for the ripple effect and tap detection
    return InkWell(
      onTap: () => _navigateToDetails(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: isDark ? CustomColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
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

            // 2. Details
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                  const SizedBox(height: 4),

                  // Submitter
                  _buildDetailRow(
                    Icons.person,
                    item.submitterName,
                    isSubtitle: true,
                  ),
                  const SizedBox(height: 4),

                  // Location
                  _buildDetailRow(
                    Icons.location_on,
                    item.location,
                  ),
                  
                  // Removed the 'View Item' button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for standardized detail rows (kept unchanged)
  Widget _buildDetailRow(IconData icon, String text, {bool isSubtitle = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: isSubtitle ? 14 : 16, color: CustomColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSubtitle ? 12 : 14,
              fontStyle: isSubtitle ? FontStyle.italic : FontStyle.normal,
              color: CustomColors.textSecondary
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}