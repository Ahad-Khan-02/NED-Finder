import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Completed_items/completed_items_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class CompletedItemsCardDetails extends StatelessWidget {
  const CompletedItemsCardDetails({
    super.key,
    required this.item,
  });

  final CompletedItemModel item;

  Widget _buildDetailRow(IconData icon, String title, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: CustomColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CustomColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black87),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    
    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      appBar: AppBar(
        title: Text('${item.name} (Completed)'),
        backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: item.imageBytes.isNotEmpty ? null : Colors.grey.shade300,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.imageBytes.isNotEmpty
                    ? Image.memory(item.imageBytes, fit: BoxFit.cover)
                    : Center(
                        child: Icon(Icons.photo, color: Colors.blueGrey.shade400, size: 60),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              item.name,
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: CustomColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border:  BoxBorder.all(color: CustomColors.success, width: 1.5)
              ),
              child: const Text(
                CustomTexts.completedItemsStatus,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.success,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Details Section
            const Text(
              CustomTexts.compltedItemandSubmitterDetails,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.primary),
            ),
            const Divider(height: 20),
            
            _buildDetailRow(Icons.person, item.submitterName, '', isDark),
            _buildDetailRow(Icons.description, CustomTexts.description, item.description, isDark),
            _buildDetailRow(Icons.search_outlined, CustomTexts.category, item.itemType.toUpperCase(), isDark),
            
            _buildDetailRow(Icons.calendar_today, CustomTexts.dateSubmitted, item.dateString, isDark),
            _buildDetailRow(Icons.access_time, CustomTexts.timeSubmitted, item.timeString, isDark),
            _buildDetailRow(Icons.location_on, CustomTexts.locationReported, item.location, isDark),
            
          ],
        ),
      ),
    );
  }
}