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

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String text,
    bool isDark, {
    required double iconSize,
    required double titleFontSize,
    required double textFontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: iconSize, color: CustomColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: textFontSize,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;
    final isLargeScreen = size.width >= 1024;

    // Responsive sizing
    final padding = isSmallScreen ? 16.0 : (isTablet ? 20.0 : 24.0);
    final imageHeight = isSmallScreen ? 250.0 : (isTablet ? 350.0 : 400.0);
    final titleFontSize = isSmallScreen ? 24.0 : 28.0;
    final sectionTitleFontSize = isSmallScreen ? 18.0 : 20.0;
    final statusFontSize = isSmallScreen ? 13.0 : 14.0;
    final detailTitleFontSize = isSmallScreen ? 13.0 : 14.0;
    final detailTextFontSize = isSmallScreen ? 15.0 : 16.0;
    final iconSize = isSmallScreen ? 18.0 : 20.0;
    final spacingAfterImage = isSmallScreen ? 16.0 : 20.0;
    final spacingAfterTitle = isSmallScreen ? 8.0 : 10.0;
    final spacingAfterStatus = isSmallScreen ? 24.0 : 30.0;
    final borderRadius = isSmallScreen ? 10.0 : 12.0;
    final statusPadding = isSmallScreen ? 8.0 : 10.0;

    // Calculate max width for large screens
    final maxWidth = isLargeScreen ? 900.0 : double.infinity;

    return Scaffold(
      backgroundColor: isDark
          ? CustomColors.darkBackground
          : CustomColors.lightBackground,
      appBar: AppBar(
        title: Text(
          '${item.name} (Completed)',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
        backgroundColor: isDark
            ? CustomColors.darkBackground
            : CustomColors.lightBackground,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Container
                Container(
                  height: imageHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: item.imageBytes.isNotEmpty
                        ? null
                        : Colors.grey.shade300,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: item.imageBytes.isNotEmpty
                        ? Image.memory(
                            item.imageBytes,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Icon(
                              Icons.photo,
                              color: Colors.blueGrey.shade400,
                              size: isSmallScreen ? 50 : 60,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: spacingAfterImage),

                // Item Name
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: spacingAfterTitle),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: statusPadding,
                    vertical: statusPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: CustomColors.success,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    CustomTexts.completedItemsStatus,
                    style: TextStyle(
                      fontSize: statusFontSize,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.success,
                    ),
                  ),
                ),
                SizedBox(height: spacingAfterStatus),

                // Details Section Header
                Text(
                  CustomTexts.compltedItemandSubmitterDetails,
                  style: TextStyle(
                    fontSize: sectionTitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primary,
                  ),
                ),
                const Divider(height: 20),

                // Detail Rows
                _buildDetailRow(
                  Icons.person,
                  'User ID:',
                  item.userId.toString(),
                  isDark,
                  iconSize: iconSize,
                  titleFontSize: detailTitleFontSize,
                  textFontSize: detailTextFontSize,
                ),
                _buildDetailRow(
                  Icons.description,
                  CustomTexts.description,
                  item.description,
                  isDark,
                  iconSize: iconSize,
                  titleFontSize: detailTitleFontSize,
                  textFontSize: detailTextFontSize,
                ),
                _buildDetailRow(
                  Icons.search_outlined,
                  CustomTexts.category,
                  item.itemType.toUpperCase(),
                  isDark,
                  iconSize: iconSize,
                  titleFontSize: detailTitleFontSize,
                  textFontSize: detailTextFontSize,
                ),
                _buildDetailRow(
                  Icons.calendar_today,
                  CustomTexts.dateSubmitted,
                  item.dateString,
                  isDark,
                  iconSize: iconSize,
                  titleFontSize: detailTitleFontSize,
                  textFontSize: detailTextFontSize,
                ),
                _buildDetailRow(
                  Icons.access_time,
                  CustomTexts.timeSubmitted,
                  item.timeString,
                  isDark,
                  iconSize: iconSize,
                  titleFontSize: detailTitleFontSize,
                  textFontSize: detailTextFontSize,
                ),
                _buildDetailRow(
                  Icons.location_on,
                  CustomTexts.locationReported,
                  item.location,
                  isDark,
                  iconSize: iconSize,
                  titleFontSize: detailTitleFontSize,
                  textFontSize: detailTextFontSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}