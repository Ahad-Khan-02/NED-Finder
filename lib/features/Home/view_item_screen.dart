import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ned_finder/Providers/Home/view_item_provider.dart';
import 'package:ned_finder/features/Home/claim_item_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/features/Home/widgets/edit_form_filed.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class ViewItemScreen extends StatefulWidget {
  final ItemModel item;
  final bool isMyItem;
  final int currentUserID;

  const ViewItemScreen({
    super.key,
    required this.item,
    required this.isMyItem,
    this.currentUserID = 0,
  });

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize provider with current item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ViewItemProvider>().setItem(widget.item);
    });
  }

  void _showEditBottomSheet(BuildContext screenContext, ItemModel item) {
    showModalBottomSheet(
      context: screenContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext sheetContext) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: EditItemForm(
              item: item,
              onSave: (sheetCtx, screenCtx, name, description, location, imageBytes, mimeType) async {
                // Use provider to edit item
                final provider = context.read<ViewItemProvider>();
                final success = await provider.editItem(
                  originalItem: item,
                  name: name,
                  description: description,
                  location: location,
                  newImageBytes: imageBytes,
                  newImageMimeType: mimeType,
                );
                
                if (!mounted) return;
                
                Navigator.of(sheetCtx).pop(); // Close bottom sheet
                
                if (success) {
                  ScaffoldMessenger.of(screenCtx).showSnackBar(
                    SnackBar(
                      content: Text(provider.successMessage ?? 'Item updated successfully!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  // Wait a bit to show the message
                  await Future.delayed(Duration(milliseconds: 1500));
                  if (!mounted) return;
                  // Pop and refresh parent
                  Navigator.of(screenCtx).pop(true);
                } else {
                  ScaffoldMessenger.of(screenCtx).showSnackBar(
                    SnackBar(
                      content: Text(provider.errorMessage ?? 'Failed to update item'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(BuildContext context, {required Uint8List imageBytes}) {
    final bool hasImage = imageBytes.isNotEmpty;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final imageHeight = isSmallScreen ? size.height * 0.35 : size.height * 0.4;

    return Container(
      height: imageHeight,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Stack(
        children: [
          hasImage
              ? Center(
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.blueGrey.shade400,
                        size: isSmallScreen ? 50 : 60,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'No Image Available',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(BuildContext context, ItemModel item) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final fontSize = isSmallScreen ? 12.0 : 14.0;
    final horizontalPadding = isSmallScreen ? 8.0 : 10.0;
    final verticalPadding = isSmallScreen ? 3.0 : 4.0;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: item.statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: item.statusColor),
          ),
          child: Text(
            item.statusText,
            style: TextStyle(
              color: item.statusColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (item.isFound)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              color: CustomColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: CustomColors.warning),
            ),
            child: Text(
              'Found',
              style: TextStyle(
                color: CustomColors.warning,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          )
      ],
    );
  }

  Widget _buildDetailSection({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final labelFontSize = isSmallScreen ? 16.0 : 18.0;
    final valueFontSize = isSmallScreen ? 14.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: CustomColors.primary, size: iconSize),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: CustomColors.primary,
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ItemModel item, ViewItemProvider provider) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final buttonFontSize = isSmallScreen ? 12.0 : 13.0;
    final mainButtonFontSize = isSmallScreen ? 14.0 : 16.0;

    return Column(
      children: [
        widget.isMyItem
            ? Row(
                children: [
                  // Mark as Found Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: provider.isMarkingAsFound
                          ? null
                          : () async {
                              final success = await provider.markAsFound(item);
                              
                              if (!mounted) return;
                              
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.successMessage!),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else if (provider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.errorMessage!),
                                  ),
                                );
                              }
                            },
                      child: provider.isMarkingAsFound
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              item.isFound ? 'FOUND' : 'Mark as Found',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: buttonFontSize,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Delete Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: provider.isDeleting
                          ? null
                          : () async {
                              // Show confirmation dialog
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Item'),
                                  content: Text('Are you sure you want to delete this item?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (confirm != true || !mounted) return;
                              
                              final success = await provider.deleteItem(item);
                              
                              if (!mounted) return;
                              
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.successMessage!),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                await Future.delayed(Duration(milliseconds: 500));
                                Navigator.of(context).pop(true); // Pass true to indicate deletion
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.errorMessage!),
                                  ),
                                );
                              }
                            },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 2, color: Colors.red),
                        backgroundColor: CustomColors.error.withOpacity(0.1),
                      ),
                      child: provider.isDeleting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : Text(
                              'Delete Item',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: buttonFontSize,
                                color: CustomColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ],
              )
            : (item.userId == widget.currentUserID)
                ? Container()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClaimItemScreen(item: item),
                          ),
                        );
                      },
                      child: Text(
                        CustomTexts.claimItemButton,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: mainButtonFontSize,
                        ),
                      ),
                    ),
                  ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              CustomTexts.close,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: mainButtonFontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;
    final isLargeScreen = size.width >= 1024;

    final padding = isSmallScreen ? 16.0 : (isTablet ? 20.0 : 24.0);
    final titleFontSize = isSmallScreen ? 24.0 : 30.0;
    final editButtonWidth = isSmallScreen ? 70.0 : 80.0;
    final editIconSize = isSmallScreen ? 14.0 : 16.0;
    final editTextSize = isSmallScreen ? 12.0 : 14.0;
    final sectionSpacing = isSmallScreen ? 16.0 : 20.0;
    final finalSpacing = isSmallScreen ? 24.0 : 30.0;
    final maxWidth = isLargeScreen ? 900.0 : double.infinity;

    return Consumer<ViewItemProvider>(
      builder: (context, viewProvider, child) {
        // Use widget.item directly since we're not updating it in place
        final displayItem = widget.item;
        
        return Scaffold(
          backgroundColor: isDark
              ? CustomColors.darkBackground
              : CustomColors.lightBackground,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImageSection(context, imageBytes: displayItem.imageBytes),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  displayItem.name,
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (widget.isMyItem && !displayItem.isFound)
                                SizedBox(
                                  width: editButtonWidth,
                                  child: ElevatedButton(
                                    onPressed: viewProvider.isEditing
                                        ? null
                                        : () => _showEditBottomSheet(context, displayItem),
                                    child: viewProvider.isEditing
                                        ? SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.edit, size: editIconSize),
                                              const SizedBox(width: 4),
                                              Text(
                                                CustomTexts.edit,
                                                style: TextStyle(fontSize: editTextSize),
                                              ),
                                            ],
                                          ),
                                  ),
                                )
                            ],
                          ),
                          if (widget.isMyItem)
                            Column(
                              children: [
                                SizedBox(height: isSmallScreen ? 8 : 10),
                                _buildStatusTag(context, displayItem),
                              ],
                            ),
                          SizedBox(height: sectionSpacing),
                          _buildDetailSection(
                            context: context,
                            icon: Icons.description,
                            label: CustomTexts.description,
                            value: displayItem.description,
                            isDark: isDark,
                          ),
                          SizedBox(height: sectionSpacing),
                          _buildDetailSection(
                            context: context,
                            icon: Icons.calendar_today,
                            label: displayItem.dateLabel,
                            value: DateFormat('yyyy-MM-dd').format(displayItem.date),
                            isDark: isDark,
                          ),
                          SizedBox(height: sectionSpacing),
                          _buildDetailSection(
                            context: context,
                            icon: Icons.location_on,
                            label: displayItem.locationLabel,
                            value: displayItem.location,
                            isDark: isDark,
                          ),
                          SizedBox(height: finalSpacing),
                          _buildActionButtons(context, displayItem, viewProvider),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}