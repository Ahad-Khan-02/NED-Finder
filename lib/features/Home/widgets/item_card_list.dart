import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/widgets/item_card.dart';

class ItemCardList extends StatelessWidget {
  final List<ItemModel> items;
  
  // Refined type from 'dynamic' to 'bool' for better type safety and clarity.
  final bool isMyItem; 
  
  final int userID;
  final VoidCallback onRefresh;

  const ItemCardList({
    super.key, 
    required this.items, 
    required this.isMyItem, 
    required this.userID,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      // The inner GridView.builder remains the same.
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.6,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ItemCard(
            item: items[index],
            isMyItem: isMyItem, // Now definitively a bool
            userID: userID,
            onItemActionSuccess: onRefresh,
          );
        },
      ),
    );
  }
}