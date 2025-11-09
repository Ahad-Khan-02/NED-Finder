import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/home_screen.dart';
import 'package:ned_finder/features/Home/widgets/custom_drawer.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; // REQUIRED for API calls

class MyItemsScreen extends StatefulWidget {
   const MyItemsScreen({super.key});

   @override
   State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
   int _selectedIndex = 1; // Default to My Items screen index
   List<ItemModel> items = []; // List to store fetched items
   bool _isLoading = true;
   String? _error;

   // ⚠️ NOTE: Replace this with actual user session data retrieval!
   // For now, we will use a dummy user ID.
   final int currentUserId = 1; 

   @override
   void initState() {
   super.initState();
   // Start fetching data immediately when the screen loads
   _fetchMyItems(); 
   }

   // --- DATA FETCHING ---
   Future<void> _fetchMyItems() async {
   try {
       // 1. Set Loading State
       setState(() {
         _isLoading = true;
         _error = null;
       });

       // 2. API Call using the path parameter
       final endpoint = 'my-items/$currentUserId';
       final responseData = await Http.get(endpoint); 

       // 3. Check Response and Parse Data
       if (responseData['status'] == 'success' && responseData['data'] != null) {
         // Assuming 'data' contains the list directly, or under an 'items' key
         final List itemsJson = responseData['data']['items'] ?? responseData['data']; 

         final List<ItemModel> fetchedItems = itemsJson
            .map((item) => ItemModel.fromJson(item))
            .toList();

         // 4. Update State with Data
         setState(() {
            items = fetchedItems;
            _isLoading = false;
         });
       } else {
         throw Exception(responseData['message'] ?? 'Failed to retrieve your items.');
       }
   } catch (e) {
       // 5. Handle Error State
       print('🚨 Error fetching my items: $e');
       setState(() {
         _error = 'Could not load your reported items. Check the network connection or try again later.';
         _isLoading = false;
       });
   }
   }

   // --- DRAWER NAVIGATION LOGIC ---
   void _onDrawerItemSelected(int index) {
   setState(() {
       _selectedIndex = index;
   });
  
   // Handle Navigation outside of this screen
   if (index == 0) {
       // Navigate to Home Screen
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
   } else if (index == 2) {
       // Navigate to Settings Screen (Example)
       print('Navigating to Settings');
       // Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
   }
   // If index == 1, stay on MyItemsScreen
   }

   // --- MAIN CONTENT (Handles Loading/Error/Data) ---
   Widget _buildMainContent() {
   // 1. Check for Errors
   if (_error != null) {
       return Center(child: Text(_error!));
   }

   // 2. Check for Loading
   if (_isLoading) {
       return const Center(child: CircularProgressIndicator());
   }

   // 3. Check for Empty Data
   if (items.isEmpty) {
       return Center(
         child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Icon(Icons.info_outline, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
                'You haven\'t reported any items yet.',
                style: TextStyle(fontSize: 16),
            ),
            TextButton(
                onPressed: _fetchMyItems,
                child: const Text('Try Reloading'),
            )
            ],
         ),
       );
   }

   // 4. Display Data
   return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         // 1. Title, Search Bar, and Action Buttons
         const HomeHeaderSection(isMyitemsScreen: true, isSettingsScreen: false),

         // 2. Item Cards List (Must be wrapped in Expanded when inside a Column/Flexible)
         Expanded(
            child: ItemCardList(items: items),
         ),
       ],
   );
   }

   // --- BUILD METHOD ---
   @override
   Widget build(BuildContext context) {
   final bool isDark = HelperFunctions.isDarkMode(context);
   return Scaffold(
       backgroundColor: isDark? CustomColors.darkBackground : CustomColors.lightBackground,
       appBar: AppBar(
         title: const Text(
            CustomTexts.appName,
            style: TextStyle(fontWeight: FontWeight.bold),
         ),
         backgroundColor: isDark? CustomColors.darkBackground : CustomColors.lightBackground,
         elevation: 0,
         foregroundColor: isDark? Colors.white : Colors.black,
       ),

       // The drawer widget
       drawer: CustomDrawer(
         selectedIndex: _selectedIndex,
         onItemSelected: _onDrawerItemSelected,
         // Assuming CustomTexts handles these, if not, hardcode or pass them from a user model
         userName: CustomTexts.userName,
         userRole: CustomTexts.userRole,
       ),

       // The main content of the screen
       body: _buildMainContent(),
   );
   }
}