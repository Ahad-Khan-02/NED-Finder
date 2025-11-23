import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/features/Home/widgets/item_card.dart';

class ItemCardList extends StatelessWidget {
  final List<ItemModel> items;
  
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
            isMyItem: isMyItem, 
            userID: userID,
            onItemActionSuccess: onRefresh,
          );
        },
      ),
    );
  }
}