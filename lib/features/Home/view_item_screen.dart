import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Required for date formatting
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/claim_item_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';

class ViewItemScreen extends StatelessWidget {
  // Pass the item data to the screen
  final ItemModel item;
  final bool isMyItem;

  const ViewItemScreen({super.key, required this.item, required this.isMyItem});

  // --- Custom Confirmation Dialog ---
  Future<bool?> _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    Color actionColor,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(title.contains('Delete') ? 'Delete' : 'Confirm'),
            ),
          ],
        );
      },
    );
  }

  // --- API Handlers ---
  Future<void> _deleteItem(BuildContext context) async {
    final bool confirm = await _showConfirmationDialog(
          context,
          'Delete Item',
          'Are you sure you want to permanently delete this item?',
          CustomColors.error,
        ) ??
        false;

    if (!confirm) return;

    // Show loading feedback
    HelperFunctions.showSnackBar('Requesting item deletion...');

    final endpoint = 'items/${item.id}?user_id=${item.userId}';

    try {
      final responseData = await Http.delete(endpoint);

      if (responseData['status'] == 'success') {
        HelperFunctions.showSnackBar(
          'Item "${item.name}" successfully deleted!',
        );
        Navigator.of(context).pop();
      } else {
        HelperFunctions.showSnackBar(
          responseData['message'] ?? 'Failed to delete item.',
        );
      }
    } catch (e) {
      HelperFunctions.showSnackBar(
        'Connection error during deletion: $e',
      );
    }
  }

  Future<void> _markAsFound(BuildContext context) async {
    final bool confirm = await _showConfirmationDialog(
          context,
          'Mark as Found',
          'Are you sure you want to mark this item as found and close the listing?',
          CustomColors.primary,
        ) ??
        false;

    if (!confirm) return;

    HelperFunctions.showSnackBar('Marking item as found...');

    final endpoint = 'items/${item.id}/found?user_id=${item.userId}';

    try {
      final responseData = await Http.put(endpoint, {});

      if (responseData['status'] == 'success') {
        HelperFunctions.showSnackBar(
          'Item "${item.name}" marked as found!',
        );
        Navigator.of(context).pop();
      } else {
        HelperFunctions.showSnackBar(
          responseData['message'] ?? 'Failed to mark item as found.',
        );
      }
    } catch (e) {
      HelperFunctions.showSnackBar(
        'Connection error while marking as found: $e',
      );
    }
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
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: Icons.category,
                    label: 'Category',
                    value: 'Item Category',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _buildStatusTag(),
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
                    onPressed: () => Navigator.of(context).pop(),
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

        item.isFound? Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: CustomColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CustomColors.warning),
          ),
          child: Text(
            item.statusText,
            style: TextStyle(
              color: CustomColors.warning,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ):Container()
      ],
    );
  }

  Widget _buildDetailRow({
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
            Icon(icon, color: isDark ? Colors.white : Colors.black, size: 24),
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
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 4),
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.grey.shade600),
          ),
        ),
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

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        item.isFound? Container():
        isMyItem
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: item.isFound ? null : () => _markAsFound(context),
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
                      onPressed: () => _deleteItem(context),
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
            onPressed: () => Navigator.of(context).pop(),
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
}
