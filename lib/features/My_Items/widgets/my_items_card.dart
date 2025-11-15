import 'dart:typed_data';
import 'package:flutter/material.dart';

// --- Necessary Imports ---
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/view_item_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';

class MyItemCard extends StatelessWidget {
  const MyItemCard({super.key, required this.item});

  final ItemModel item;

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
          'Confirm Delete',
          CustomColors.error,
        ) ??
        false;

    if (!confirm) return;

    HelperFunctions.showSnackBar('Requesting item deletion...');

    final endpoint = 'items/${item.id}?user_id=${item.userId}';

    try {
      final responseData = await Http.delete(endpoint);

      if (responseData['status'] == 'success') {
        HelperFunctions.showSnackBar(
          'Item "${item.name}" successfully deleted!',
        );
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
          'Confirm Found',
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
    final Uint8List bytes = item.imageBytes;
    final bool hasImage = bytes.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? CustomColors.dark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    color: Colors.grey.shade300,
                  ),
                  child: Center(
                    child: hasImage
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.memory(
                              bytes,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),

                // Label (Found/Missing)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.labelColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.labelText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Status Tag
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Text + Buttons Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                Text(
                  item.description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    // Mark as Found
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

                    // Delete
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
                ),

                const SizedBox(height: 8),

                // View Details
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewItemScreen(item: item,isMyItem: true,)),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side:
                          BorderSide(color: isDark ? Colors.white70 : Colors.black45, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      CustomTexts.viewItem,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
