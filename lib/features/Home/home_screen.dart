import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/widgets/custom_drawer.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/features/Settings/settings_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';
// Note: Removed unused color imports from the class body

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // Initialize items list as empty and handle loading state
  List<ItemModel> items = [];
  bool _isLoading = true; // State to track if data is being fetched

  // You can remove the hardcoded 'items' and 'myItems' lists now,
  // as they will be populated from the API.

  // In _HomeScreenState in home.dart

Future<void> _fetchItems() async {
    try {
      // 1. Start Loading State
      setState(() {
        _isLoading = true;
      });

      print('Attempting to fetch items from: items/all');
      // 2. Make the API call (Using 'items/all' based on your FastAPI log)
      final responseData = await Http.get('items/all'); 
      print('Response received successfully.');

      // 3. Check Response Status and Data
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'];

        // 4. Map JSON to ItemModel using the factory constructor
        final List<ItemModel> fetchedItems = itemsJson
            .map((item) => ItemModel.fromJson(item))
            .toList();

        // 5. SUCCESS: Update State and disable loading
        setState(() {
          items = fetchedItems;
          _isLoading = false; 
        });
        print('Successfully loaded ${items.length} items.');

      } else {
        // Handle non-success status
        throw Exception('API call successful but failed to retrieve items (Status: ${responseData['status']}).');
      }
    } catch (e) {
      // 6. ERROR HANDLING: CRITICAL STEP
      print('🚨 Error fetching and parsing items: $e');
      // If any error occurs (network failure or JSON parsing crash), 
      // we MUST set _isLoading to false so the user isn't stuck on the spinner.
      setState(() {
        _isLoading = false; 
        // Optional: Show a user-friendly error message, e.g., SnackBar
      });
    }
  }

  // --- Override initState to call the fetch method ---
  @override
  void initState() {
    super.initState();
    _fetchItems(); // Start fetching data when the widget initializes
  }
  
  // --- Modified _buildMainContent to handle loading state ---
  @override
  Widget _buildMainContent() {
    // Show a loading indicator if data is being fetched
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch(_selectedIndex){
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeaderSection(isSettingsScreen: false,),
            // Use the fetched 'items' list
            Expanded(child: ItemCardList(items: items,)), 
          ],
        );
      case 1:
        // You would need a separate API call for 'myItems' (user-specific items)
        // or filter the 'items' list if your current API endpoint returns all.
        // For now, let's just display all items for this case too, or implement
        // a separate `_fetchMyItems` method.
        // Example: Filter logic (assuming user_id is known, e.g., '1')
        final myItemsFiltered = items.where((item) => item.id == '1' /* Replace with actual user_id check */).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeaderSection(isMyitemsScreen: true, isSettingsScreen: false,),
            Expanded(child: ItemCardList(items: myItemsFiltered,)),
          ],
        );
    
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeaderSection(isSettingsScreen: true,),
            const SettingsContent(),
          ],
        );
    }
  }

  // Method to update the selected index when an item is tapped in the Drawer
  void _onDrawerItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here (e.g., switch screen content based on index)
    print('Navigation Item Selected: $index');
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