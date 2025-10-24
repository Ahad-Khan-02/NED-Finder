import 'package:flutter/material.dart';
import 'package:ned_finder/features/Home/widgets/custom_drawer.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
// Note: Removed unused color imports from the class body

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Tracks the selected item for highlight

  // Method to update the selected index when an item is tapped in the Drawer
  void _onDrawerItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here (e.g., switch screen content based on index)
    print('Navigation Item Selected: $index');
  }

  // --- MAIN CONTENT (Assembles the custom widgets) ---
  Widget _buildMainContent() {
    // We only show the "Home" content when index 0 is selected.
    // For other indices, you would return the MyItemsScreen or SettingsScreen.
    if (_selectedIndex != 0) {
      return Center(
        child: Text(
          'Viewing ${[CustomTexts.home, CustomTexts.myItems, CustomTexts.settings][_selectedIndex]} Screen',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        // 1. Title, Search Bar, and Action Buttons
        HomeHeaderSection(),

        // 2. Item Cards List
        ItemCardList(),
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