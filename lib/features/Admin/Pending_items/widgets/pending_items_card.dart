import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';


class AdminPendingItemCard extends StatelessWidget {
  const AdminPendingItemCard({
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
              // Replace with actual Image.asset(item.imageUrl) or Image.network
            ),
            // Placeholder content based on image name
            child: Image.asset(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(Icons.error_outline, color: Colors.blueGrey.shade400)),
            ),
          ),

          // 2. Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
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

                // Action Buttons (Approve / Delete)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () { /* TODO: Approve Logic */ },
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
                        onPressed: () { /* TODO: Delete Logic */ },
                        style: OutlinedButton.styleFrom(
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
        ],
      ),
    );
  }

  // Helper method for standardized detail rows
  Widget _buildDetailRow(IconData icon, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}