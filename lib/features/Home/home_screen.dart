// import 'package:flutter/material.dart';
// import 'package:ned_finder/Models/item_model.dart';
// import 'package:ned_finder/features/Home/widgets/custom_drawer.dart';
// import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
// import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
// import 'package:ned_finder/features/My_Items/my_items_screen.dart';
// import 'package:ned_finder/features/Settings/settings_screen.dart';
// import 'package:ned_finder/utils/constants/colors.dart';
// import 'package:ned_finder/utils/constants/texts.dart';
// import 'package:ned_finder/utils/helpers/helper_functions.dart';
// import 'package:ned_finder/utils/http/http_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // Note: Removed unused color imports from the class body

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   // Initialize items list as empty and handle loading state
//   List<ItemModel> items = [];
//   bool _isLoading = true; // State to track if data is being fetched
//   int? currentUserId;

//   // You can remove the hardcoded 'items' and 'myItems' lists now,
//   // as they will be populated from the API.

//   // In _HomeScreenState in home.dart

// Future<void> _fetchItems() async {

//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('user_id');


//     try {
//       // 1. Start Loading State
//       setState(() {
//         _isLoading = true;
//         currentUserId = userId;
//       });

//       print('Attempting to fetch items from: items/approved');
//       // 2. Make the API call (Using 'items/all' based on your FastAPI log)
//       final responseData = await Http.get('items/approved'); 
//       print('Response received successfully.');

//       // 3. Check Response Status and Data
//       if (responseData['status'] == 'success' && responseData['data'] != null) {
//         final List itemsJson = responseData['data']['items'];

//         // 4. Map JSON to ItemModel using the factory constructor
//         final List<ItemModel> fetchedItems = itemsJson
//             .map((item) => ItemModel.fromJson(item))
//             .toList();

//         // 5. SUCCESS: Update State and disable loading
//         setState(() {
//           items = fetchedItems;
//           _isLoading = false; 
//         });
//         print('🚨 Successfully loaded ${items.length} items.');

//       } else {
//         // Handle non-success status
//         throw Exception('API call successful but failed to retrieve items (Status: ${responseData['status']}).');
//       }
//     } catch (e) {
//       // 6. ERROR HANDLING: CRITICAL STEP
//       print('🚨 Error fetching and parsing items: $e');
//       // If any error occurs (network failure or JSON parsing crash), 
//       // we MUST set _isLoading to false so the user isn't stuck on the spinner.
//       setState(() {
//         _isLoading = false; 
//         // Optional: Show a user-friendly error message, e.g., SnackBar
//       });
//     }
//   }

//   // --- Override initState to call the fetch method ---
//   @override
//   void initState() {
//     super.initState();
//     _fetchItems(); // Start fetching data when the widget initializes
//   }
  
//   // --- Modified _buildMainContent to handle loading state ---
//   Widget _buildMainContent() {
//     // Show a loading indicator if data is being fetched
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     switch(_selectedIndex){
//       case 0:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const HomeHeaderSection(isSettingsScreen: false,),
//             // Use the fetched 'items' list
//             Expanded(child: ItemCardList(items: items,isMyItem: false,userID : currentUserId!)), 
//           ],
//         );
//       case 1:
//         // You would need a separate API call for 'myItems' (user-specific items)
//         // or filter the 'items' list if your current API endpoint returns all.
//         // For now, let's just display all items for this case too, or implement
//         // a separate `_fetchMyItems` method.
//         // Example: Filter logic (assuming user_id is known, e.g., '1')
        
//         return  const MyItemsContent();
    
//       default:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//              HomeHeaderSection(isSettingsScreen: true,),
//              SettingsContent(userID:currentUserId! ,),
//           ],
//         );
//     }
//   }

//   // Method to update the selected index when an item is tapped in the Drawer
//   void _onDrawerItemSelected(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     // Add navigation logic here (e.g., switch screen content based on index)
//     print('Navigation Item Selected: $index');
//   }

//   // --- BUILD METHOD ---
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = HelperFunctions.isDarkMode(context);
//     return Scaffold(
//       backgroundColor: isDark? CustomColors.darkBackground : CustomColors.lightBackground,
//       appBar: AppBar(
//         title: const Text(
//           CustomTexts.appName,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: isDark? CustomColors.darkBackground : CustomColors.lightBackground,
//         elevation: 0,
//         foregroundColor: isDark? Colors.white : Colors.black,
//       ),

//       // The drawer widget
//       drawer: CustomDrawer(
//         selectedIndex: _selectedIndex,
//         onItemSelected: _onDrawerItemSelected,
//         userId: currentUserId!,
//         // Assuming CustomTexts handles these, if not, hardcode or pass them from a user model
//       ),

//       // The main content of the screen
//       body: _buildMainContent(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/widgets/custom_drawer.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/features/My_Items/my_items_screen.dart';
import 'package:ned_finder/features/Settings/settings_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

   @override
   State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   int _selectedIndex = 0;
  
   // State variables for items and filtering
   List<ItemModel> items = [];
   List<ItemModel> _filteredItems = []; // List used for displaying filtered/searched results
   String _searchQuery = ''; // The current search term
   bool _isLoading = true; 
   int? currentUserId;

   // Function to apply the search filter to the displayed items
   void _runSearchFilter(String query) {
     setState(() {
        _searchQuery = query;

        if (query.isEmpty) {
          // If the query is empty, show all items
          _filteredItems = items;
        } else {
          // Filter based on item name or description (case-insensitive)
          final searchLower = query.toLowerCase();
          _filteredItems = items.where((item) {
             final nameLower = item.name.toLowerCase();
             final descriptionLower = item.description.toLowerCase();

             return nameLower.contains(searchLower) || descriptionLower.contains(searchLower);
          }).toList();
        }
     });
   }


   Future<void> _fetchItems() async {
     final prefs = await SharedPreferences.getInstance();
     final userId = prefs.getInt('user_id');

     try {
        // 1. Start Loading State & Set User ID
        setState(() {
          _isLoading = true;
          currentUserId = userId; // Set the user ID as soon as possible
        });

        print('Attempting to fetch items from: items/approved');
        final responseData = await Http.get('items/approved'); 
        print('Response received successfully.');

        // 2. Check Response Status and Data
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final List itemsJson = responseData['data']['items'];

          // 3. Map JSON to ItemModel using the factory constructor
          final List<ItemModel> fetchedItems = itemsJson
               .map((item) => ItemModel.fromJson(item))
               .toList();

          final List<ItemModel> notFoundItems = fetchedItems
               .where((item) => !item.isFound)
               .toList();

          // 4. SUCCESS: Update State, initialize filtered list, and disable loading
          setState(() {
             items = notFoundItems;
             _filteredItems = notFoundItems; // Initialize with all fetched items
             _isLoading = false; 
          });
          print('🚨 Successfully loaded ${items.length} items.');

        } else {
          throw Exception('API call successful but failed to retrieve items (Status: ${responseData['status']}).');
        }
     } catch (e) {
        print('🚨 Error fetching and parsing items: $e');
        setState(() {
          _isLoading = false; 
          // Note: currentUserId remains what was fetched from SharedPreferences (could be null)
        });
     }
   }

   @override
   void initState() {
     super.initState();
     _fetchItems(); // Start fetching data when the widget initializes
   }
  
   // --- Modified _buildMainContent to handle loading state ---
   Widget _buildMainContent() {
     // Show a loading indicator if data is being fetched or user ID is unknown
     if (_isLoading || currentUserId == null) {
        return const Center(child: CircularProgressIndicator());
     }

     switch(_selectedIndex){
        case 0:
          return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               HomeHeaderSection(
                  isSettingsScreen: false,
                  onSearchChanged: _runSearchFilter, // Pass the search filter function
               ),
               // Use the filtered/searched list
               _filteredItems.isEmpty? Center(child: Text("No items found.")) :Expanded(child: ItemCardList(items: _filteredItems,isMyItem: false,userID : currentUserId!,onRefresh: _fetchItems)), 
             ],
          );
        case 1:
          return  const MyItemsContent();

        default:
          return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                 HomeHeaderSection(isSettingsScreen: true,),
                 SettingsContent(userID:currentUserId! ,),
             ],
          );
     }
   }

   // Method to update the selected index when an item is tapped in the Drawer
   void _onDrawerItemSelected(int index) {
     setState(() {
        _selectedIndex = index;
        _fetchItems();
     });
     print('Navigation Item Selected: $index');
   }

   // --- BUILD METHOD ---
   @override
   Widget build(BuildContext context) {
     final bool isDark = HelperFunctions.isDarkMode(context);

     // Essential Check: Show a full loading screen if currentUserId is not yet set
     if (currentUserId == null && _isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
     }

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

        // The drawer widget (Now safe to use currentUserId! because of the check above)
        drawer: CustomDrawer(
          selectedIndex: _selectedIndex,
          onItemSelected: _onDrawerItemSelected,
          userId: currentUserId!,
        ),

        // The main content of the screen
        body: _buildMainContent(),
     );
   }
}