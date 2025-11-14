import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Completed_items/completed_items_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class AdminCompletedItemsCard extends StatelessWidget {
  const AdminCompletedItemsCard({
    super.key,
    required this.item,
  });

  final CompletedItemModel item;

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final bool hasImage = item.imageBytes.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? CustomColors.dark : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Display
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              color: hasImage ? null : Colors.grey.shade300,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: hasImage
                  ? Image.memory(
                      item.imageBytes, // Use decoded image bytes
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
          Expanded( 
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Removed mainAxisAlignment.spaceBetween since buttons are not needed here
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
                    item.name, // Mapped from item_name
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
                    item.submitterName, // Uses placeholder logic from model
                    isSubtitle: true,
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  _buildDetailRow(
                    Icons.description, 
                    item.description, // Mapped from item_description
                    maxLines: 2
                  ),
                  const SizedBox(height: 8),

                  // Date and Time
                  _buildDetailRow(
                    Icons.calendar_today, 
                    '${item.dateString} at ${item.timeString}', // Mapped from dateSubmitted
                  ),
                  const SizedBox(height: 8),

                  // Location
                  _buildDetailRow(
                    Icons.location_on, 
                    item.location, // Mapped from location
                  ),
                  
                  // No Action Buttons needed for 'Completed' items
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for standardized detail rows
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