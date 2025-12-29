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

  // Calculate responsive cross axis count based on screen width
  int _getCrossAxisCount(double width) {
    if (width < 600) {
      return 2; // Mobile: 2 columns
    } else if (width < 900) {
      return 2; // Small tablet: 2 columns
    } else if (width < 1200) {
      return 3; // Large tablet: 3 columns
    } else if (width < 1600) {
      return 4; // Desktop: 4 columns
    } else {
      return 5; // Large desktop: 5 columns
    }
  }

  // Calculate responsive child aspect ratio
  double _getChildAspectRatio(double width) {
    if (width < 600) {
      return 0.65; // Mobile: Taller cards for 2 columns
    } else if (width < 900) {
      return 0.70; // Small tablet
    } else if (width < 1200) {
      return 0.65; // Large tablet
    } else {
      return 0.70; // Desktop: Balanced ratio
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive padding and spacing
    final padding = isSmallScreen ? 16.0 : (isTablet ? 20.0 : 24.0);
    final gridSpacing = isSmallScreen ? 12.0 : (isTablet ? 16.0 : 20.0);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(size.width),
          crossAxisSpacing: gridSpacing,
          mainAxisSpacing: gridSpacing,
          childAspectRatio: _getChildAspectRatio(size.width),
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