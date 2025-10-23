import 'package:flutter/material.dart';
import 'package:ned_finder/features/Home/widgets/item_card.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class ItemCardList extends StatelessWidget {
  const ItemCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        scrollDirection: Axis.vertical,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ItemCard(
                title: 'Wallet',
                description: 'This is for testing for found item',
                status: CustomTexts.statusFound,
                statusColor: Colors.green,
              ),
              SizedBox(width: 20),
              ItemCard(
                title: 'ID Lace',
                description: 'QLFU ID Lace, green and black silk linen',
                status: CustomTexts.statusMissing,
                statusColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Add more rows/cards here if needed...
        ],
      ),
    );
  }
}