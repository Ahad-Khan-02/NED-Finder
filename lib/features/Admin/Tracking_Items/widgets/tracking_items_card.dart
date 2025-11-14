import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Tracking_items/tracking_items_model.dart';
import 'package:ned_finder/features/Admin/Tracking_Items/widgets/view_response_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class AdminTrackingItemCard extends StatelessWidget {
  const AdminTrackingItemCard({
    super.key,
    required this.item,
  });

  // Change model type to TrackingItemModel
  final TrackingItemModel item; 

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
          // 1. Image Display (Updated to use item.imageBytes)
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
          Expanded( // Added Expanded here to push button to the bottom
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (item.name)
                      Text(
                        item.name, // Use item.name
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
                        item.submitterName, // Use item.submitterName
                        isSubtitle: true,
                      ),
                      const SizedBox(height: 8),

                      // Description
                      _buildDetailRow(
                        Icons.description, 
                        item.description, // Use item.description
                        maxLines: 2
                      ),
                      const SizedBox(height: 8),

                      // Date
                      _buildDetailRow(
                        Icons.calendar_today, 
                        '${item.dateString} at ${item.timeString}', // Use dateString and timeString
                      ),
                      const SizedBox(height: 8),

                      // Location
                      _buildDetailRow(
                        Icons.location_on, 
                        item.location, // Use item.location
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),

                  // 3. Action Button (View Response)
                  Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () { 
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Pass the correct TrackingItemModel
                                builder: (context) => ViewResponseScreen(item: item), 
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('View Response'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for standardized detail rows (copied from original)
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