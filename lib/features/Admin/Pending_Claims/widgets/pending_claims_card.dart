import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Claims/pending_claim_model.dart';
import 'package:ned_finder/features/Admin/Pending_Claims/widgets/view_response_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';

class AdminPendingClaimsCard extends StatelessWidget {
  final PendingClaimModel claim;
  final VoidCallback onClaimProcessed;

  const AdminPendingClaimsCard({
    super.key,
    required this.claim,
    required this.onClaimProcessed,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = claim.itemImageBytes.isNotEmpty;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive sizing
    final cardPadding = isSmallScreen ? 12.0 : 16.0;
    final imageHeight = isSmallScreen ? 160.0 : (isTablet ? 180.0 : 200.0);
    final titleFontSize = isSmallScreen ? 16.0 : 18.0;
    final userFontSize = isSmallScreen ? 13.0 : 14.0;
    final timeFontSize = isSmallScreen ? 12.0 : 13.0;
    final statusFontSize = isSmallScreen ? 11.0 : 12.0;
    final iconSize = isSmallScreen ? 14.0 : 16.0;
    final borderRadius = isSmallScreen ? 10.0 : 12.0;
    final statusPadding = isSmallScreen ? 8.0 : 10.0;
    final spacingBetweenElements = isSmallScreen ? 6.0 : 8.0;
    final spacingAfterImage = isSmallScreen ? 10.0 : 12.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewResponseScreen(claim: claim),
            ),
          );
          onClaimProcessed();
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Container
              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: hasImage
                      ? Image.memory(
                          claim.itemImageBytes,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.broken_image,
                              size: isSmallScreen ? 36 : 40,
                            ),
                          ),
                        )
                      : Container(
                          color: CustomColors.info.withOpacity(0.1),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  color: CustomColors.info,
                                  size: isSmallScreen ? 32 : 36,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'No Item Image',
                                  style: TextStyle(
                                    color: CustomColors.info,
                                    fontSize: isSmallScreen ? 11 : 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: spacingAfterImage),

              // Item Name
              Text(
                claim.itemName,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacingBetweenElements),

              // Claimer Username
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: iconSize,
                    color: CustomColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Claimer: ${claim.username}',
                      style: TextStyle(
                        fontSize: userFontSize,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacingBetweenElements / 2),

              // Date and Time
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: iconSize,
                    color: CustomColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${claim.dateString} ${claim.timeString}',
                      style: TextStyle(
                        fontSize: timeFontSize,
                        color: CustomColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacingBetweenElements),

              // Status Badge
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: statusPadding,
                    vertical: statusPadding / 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    claim.status.toUpperCase(),
                    style: TextStyle(
                      color: CustomColors.warning,
                      fontWeight: FontWeight.bold,
                      fontSize: statusFontSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}