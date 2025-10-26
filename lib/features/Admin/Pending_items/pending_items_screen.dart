import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart';
import 'package:ned_finder/features/Admin/Pending_items/widgets/pending_items_card.dart';
import 'package:ned_finder/utils/constants/colors.dart';

class PendingItemsScreen extends StatelessWidget {
  PendingItemsScreen({super.key});

  // Dummy data based on the "Pending Items" image
  final List<PendingItemModel> dummyPendingItems = [
    // Item 1: Alaga ko si beru
    PendingItemModel(
      title: 'Alaga ko si beru',
      description: 'Isa siyang malaking insecto na kulay black and purple',
      date: '2024-06-05',
      location: 'Jeju island',
      imageUrl: 'assets/images/beru.jpg', // Placeholder image path
      statusColor: Colors.purple,
    ),
    // Item 2: karapatan q
    PendingItemModel(
      title: 'karapatan q',
      description: 'matagal na kasing nawawala karapatan q kasama natin ng pake q, pahanap nalang po',
      date: '2004-11-04',
      location: 'basta nasa pilipinas lang yon di panaman aq nakakaalis ng bansa e',
      imageUrl: 'assets/images/star.jpg', // Placeholder image path
      statusColor: Colors.blue,
    ),
    // Item 3: menudo
    PendingItemModel(
      title: 'menudo',
      description: 'huhu miss ko na siya',
      date: '2024-06-29',
      location: 'sa tabi tabi lang',
      imageUrl: 'assets/images/frog.jpg', // Placeholder image path
      statusColor: CustomColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pending Items',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            
            // Grid View of Cards
            GridView.builder(
              shrinkWrap: true, // Crucial for embedding GridView inside SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350, // Max width of each card
                childAspectRatio: 0.8, // Adjusted to fit image + title + 4 details + 2 buttons
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: dummyPendingItems.length,
              itemBuilder: (context, index) {
                return AdminPendingItemCard(item: dummyPendingItems[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}