import 'package:flutter/material.dart';
// Assuming PendingItemModel and AdminPendingItemCard are compatible for tracking items
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart'; 
import 'package:ned_finder/features/Admin/Tracking_Items/widgets/tracking_items_card.dart'; 
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

// Note: The card widget name AdminPendingItemCard suggests it might need renaming
// in a real app, but we will reuse it here as instructed.

class TrackingItemsScreen extends StatelessWidget {
  TrackingItemsScreen({super.key});

  // Dummy data based on the "Tracking Items" image and a similar structure
  final List<PendingItemModel> dummyTrackingItems = [
    // Item 1: Wallet (from image)
    PendingItemModel(
      title: 'Wallet',
      description: 'This is for testing for found item',
      date: '2024-06-15',
      location: 'CAS - ROOM 404',
      imageUrl: 'assets/images/wallet.jpg', // Placeholder image path
      statusColor: CustomColors.warning, // Example status color for 'Tracking'
    ),
    // Item 2: ID Lace (from image)
    PendingItemModel(
      title: 'ID Lace',
      description: 'OLFU ID Lace, green and black silk linen',
      date: '2024-06-29',
      location: 'EARIST registrar',
      imageUrl: 'assets/images/iamge.png', // Placeholder image path
      statusColor: CustomColors.info, // Another example status color
    ),
    // Item 3: Samsung Phone
    PendingItemModel(
      title: 'Samsung Phone',
      description: 'Lost a blue Samsung Galaxy S21 in the library.',
      date: '2024-10-01',
      location: 'Main Library, 2nd Floor',
      imageUrl: 'assets/images/iamge.png', // Placeholder image path
      statusColor: Colors.amber, 
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    
    return Scaffold(
      // The background color logic is reused from your original file
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Title
            const Text(
              // Changed the title to "Tracking Items"
              'Tracking Items',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Grid View of Cards
            GridView.builder(
              // Properties reused from PendingItemsScreen
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(), 
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350, // Max width of each card
                childAspectRatio: 0.8, 
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: dummyTrackingItems.length,
              itemBuilder: (context, index) {
                // Using the AdminPendingItemCard with the tracking data
                return AdminTrackingItemCard(item: dummyTrackingItems[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}