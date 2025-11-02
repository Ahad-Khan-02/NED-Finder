import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart';
import 'package:ned_finder/features/Admin/Tracking_Items/widgets/view_response_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class AdminTrackingItemCard extends StatelessWidget {
  const AdminTrackingItemCard({
    super.key,
    required this.item,
  });

  final PendingItemModel item;

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);

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
          // 1. Image Placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              color: Colors.grey.shade300,
            ),
            child: Image.asset(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(Icons.error_outline, color: Colors.blueGrey.shade400)),
            ),
          ),

          // 2. Details
          Expanded( // Added Expanded here to push buttons to the bottom
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      _buildDetailRow(
                        Icons.description, 
                        item.description, 
                        maxLines: 2
                      ),
                      const SizedBox(height: 8),

                      // Date
                      _buildDetailRow(
                        Icons.calendar_today, 
                        item.date,
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

                  // 3. Action Button (View Response)
                  Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (
                          ) { 
                            Navigator.push(
                              context,
                              MaterialPageRoute(
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
  Widget _buildDetailRow(IconData icon, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16,),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}