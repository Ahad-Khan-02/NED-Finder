import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/view_item_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.statusColor,
    // Note: imageUrl would be used with Image.asset or Image.network
  });

  final String title;
  final String description;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    
    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: isDark? CustomColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(10),
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
            // Image and Status Tag
            Stack(
              children: [
                // Placeholder for Image (Replace with actual Image.asset)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    color: Colors.grey.shade300,
                  ),
                  child: Center(
                      child: Icon(Icons.image,color: Colors.blueGrey,)
                )),
                // Status Tag
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
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

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),

                  // View Item Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final exampleFoundItem = ItemModel(
                          id: '123',
                          name: 'Leather Wallet',
                          category: 'Wallet/Purse',
                          date: DateTime(2024, 8, 16),
                          location: 'CAS - ROOM 404',
                          description: 'This is for testing for found item. It is made of brown leather with a snake-skin pattern and has four card slots inside.',
                          imageUrl: 'assets/images/wallet.jpg', // MUST be a valid asset path
                          status: ItemStatus.found,
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewItemScreen(item: exampleFoundItem)));
                      },
                      child: const Text(
                        CustomTexts.viewItem,
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}