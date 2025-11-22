import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/claim_item_screen.dart';
import 'package:ned_finder/features/Home/widgets/api_call_functions.dart';
import 'package:ned_finder/features/Home/widgets/edit_form_filed.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

// --- 2. Main View Item Screen Widget ---

class ViewItemScreen extends StatelessWidget {
  // Pass the item data to the screen
  final ItemModel item;
  final bool isMyItem;
  final int currentUserID;

  const ViewItemScreen(
      {super.key, required this.item, required this.isMyItem, this.currentUserID = 0});

  // New method to show the bottom sheet for editing
  void _showEditBottomSheet(BuildContext screenContext) {
    showModalBottomSheet(
      context: screenContext,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext sheetContext) { // sheetContext is the bottom sheet context
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: EditItemForm(
              item: item,
              // Pass the external API call function to the form's onSave callback
              onSave: (sheetContext, screenContext, name, description, location, newImageBytes, newImageMimeType) {
                editItemApiCall(
                  sheetContext: sheetContext, 
                  screenContext: screenContext,
                  originalItem: item, // Pass the original item to get the ID/User ID
                  name: name,
                  description: description,
                  location: location,
                  newImageBytes: newImageBytes,
                  newImageMimeType: newImageMimeType,
                );
              },
            ),
          ),
        );
      },
    );
  }

  // --- Widget Builders ---

  Widget _buildImageSection(BuildContext context, {required Uint8List imageBytes}) {
    final bool hasImage = imageBytes.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Stack(
        children: [
          hasImage
              ? Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.broken_image, color: Colors.blueGrey.shade400, size: 60),
                  ),
                )
              : const Center(
                  child: Text(
                    'No Image Available',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(false), // Pop with false on simple back
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 10),
        item.isFound
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    fontSize: 14,
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: isDark ? Colors.white : Colors.black87, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black87),
        ),
      ],
    );
  }
  
  // Note: The original _buildDetailRow was similar to _buildDetailSection,
  // combining them for brevity and using the 'Description' style for all.
  Widget _buildCategoryRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return _buildDetailSection(icon: icon, label: label, value: value, isDark: isDark);
  }


  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        isMyItem
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: item.isFound
                          ? () {
                              HelperFunctions.showSnackBar('Item already found');
                            }
                          : (item.statusText == 'REJECTED' || item.statusText == 'PENDING')
                              ? () {
                                    HelperFunctions.showSnackBar('Item not approved');
                                }
                              : () => markAsFoundApiCall(context, item), // Using external API call
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 3,
                      ),
                      child: Text(
                        item.isFound ? 'FOUND' : 'Mark as Found',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => deleteItemApiCall(context, item), // Using external API call
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.error.withOpacity(0.9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Delete Item',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            : (item.userId == currentUserID)
                ? Container()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Claim Item Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClaimItemScreen(item: item),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Claim This Item',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // We use pop(false) here to ensure a simple 'Close' does not trigger a refresh
            onPressed: () => Navigator.of(context).pop(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: CustomColors.textSecondary,
              elevation: 0,
              side: BorderSide(color: CustomColors.textSecondary.withOpacity(0.5)),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageSection(context, imageBytes: item.imageBytes),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      if (isMyItem && !item.isFound) // Only show edit if it's my item and not yet found/closed
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            onPressed: () => _showEditBottomSheet(context), 
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, size: 16),
                                SizedBox(width: 5),
                                Text('Edit', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildCategoryRow(
                    icon: Icons.category,
                    label: 'Category',
                    value: 'Item Category', // Placeholder, update if ItemModel supports category
                    isDark: isDark,
                  ),
                  isMyItem? Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildStatusTag(),
                    ],
                  ):Container(),
                  const SizedBox(height: 20),
                  _buildDetailSection(
                    icon: Icons.description,
                    label: 'Description',
                    value: item.description,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailSection(
                    icon: Icons.calendar_today,
                    label: item.dateLabel,
                    value: DateFormat('yyyy-MM-dd').format(item.date),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailSection(
                    icon: Icons.location_on,
                    label: item.locationLabel,
                    value: item.location,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 30),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}