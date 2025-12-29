import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Completed_items/completed_items_model.dart';
import 'package:ned_finder/features/Admin/Completed_Items/widgets/completed_items_card_details.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class AdminCompletedItemsCard extends StatelessWidget {
  const AdminCompletedItemsCard({
    super.key,
    required this.item,
  });

  final CompletedItemModel item;

  void _handleTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletedItemsCardDetails(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final bool hasImage = item.imageBytes.isNotEmpty;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive sizing
    final imageHeight = isSmallScreen ? 180.0 : (isTablet ? 160.0 : 150.0);
    final cardPadding = isSmallScreen ? 12.0 : (isTablet ? 14.0 : 16.0);
    final titleFontSize = isSmallScreen ? 16.0 : 18.0;
    final detailFontSize = isSmallScreen ? 13.0 : 14.0;
    final iconSize = isSmallScreen ? 15.0 : 16.0;
    final tagFontSize = isSmallScreen ? 11.0 : 12.0;
    final tagPadding = isSmallScreen ? 6.0 : 8.0;
    final spacingBetweenElements = isSmallScreen ? 6.0 : 8.0;
    final borderRadius = isSmallScreen ? 12.0 : 15.0;

    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? CustomColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
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
            // Image Container
            Container(
              height: imageHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadius),
                ),
                color: hasImage ? null : Colors.grey.shade300,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadius),
                ),
                child: hasImage
                    ? Image.memory(
                        item.imageBytes,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.blueGrey.shade400,
                            size: isSmallScreen ? 36 : 40,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.blueGrey.shade400,
                          size: isSmallScreen ? 36 : 40,
                        ),
                      ),
              ),
            ),

            // Card Details
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Type Tag
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: tagPadding,
                        vertical: tagPadding / 2,
                      ),
                      decoration: BoxDecoration(
                        color: item.itemType == 'lost'
                            ? CustomColors.error.withOpacity(0.1)
                            : CustomColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        item.itemType.toUpperCase(),
                        style: TextStyle(
                          fontSize: tagFontSize,
                          fontWeight: FontWeight.bold,
                          color: item.itemType == 'lost'
                              ? CustomColors.error
                              : CustomColors.success,
                        ),
                      ),
                    ),
                    SizedBox(height: spacingBetweenElements),

                    // Item Name
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacingBetweenElements),

                    // User ID
                    _buildDetailRow(
                      Icons.person,
                      'User ID: ${item.userId.toString()}',
                      isDark,
                      iconSize: iconSize,
                      fontSize: detailFontSize,
                    ),
                    SizedBox(height: spacingBetweenElements),

                    // Description
                    _buildDetailRow(
                      Icons.description,
                      item.description,
                      isDark,
                      iconSize: iconSize,
                      fontSize: detailFontSize,
                    ),
                    SizedBox(height: spacingBetweenElements),

                    // Date and Time
                    _buildDetailRow(
                      Icons.calendar_today,
                      '${item.dateString} at ${item.timeString}',
                      isDark,
                      iconSize: iconSize,
                      fontSize: detailFontSize,
                    ),
                    SizedBox(height: spacingBetweenElements),

                    // Location
                    _buildDetailRow(
                      Icons.location_on,
                      item.location,
                      isDark,
                      iconSize: iconSize,
                      fontSize: detailFontSize,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String text,
    bool isDark, {
    bool isSubtitle = false,
    required double iconSize,
    required double fontSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: isSubtitle ? iconSize - 2 : iconSize,
          color: isDark
              ? CustomColors.lightBackground
              : CustomColors.darkBackground,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSubtitle ? fontSize - 2 : fontSize,
              fontStyle: isSubtitle ? FontStyle.italic : FontStyle.normal,
              color: isDark
                  ? CustomColors.lightBackground
                  : CustomColors.darkBackground,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}