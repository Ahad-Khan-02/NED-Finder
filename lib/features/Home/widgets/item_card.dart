import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/view_item_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item,required this.isMyItem});

  final ItemModel item;
  
  final bool isMyItem;

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

          // ✅ Image grows to fit card
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
                         child: 
                            // 🎯 FIX: Display the image using Image.memory with the decoded bytes
                      hasImage
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
                isMyItem?  Positioned(
                    bottom: 1,
                    left: 1,
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
                  ):Container(),
              ],
            ),
          ),

          // ✅ Text & button area
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // prevents overflow
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

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ViewItemScreen(item: item,isMyItem: isMyItem)),
                      );
                    },
                    child: const Text(
                      CustomTexts.viewItem,
                      style: TextStyle(fontWeight: FontWeight.bold),
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
