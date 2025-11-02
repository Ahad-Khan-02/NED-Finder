import 'package:flutter/material.dart';
import 'package:ned_finder/features/Admin/Admin_Dashboard/widgets/admin_data_tables.dart';
import 'package:ned_finder/features/Admin/Admin_Dashboard/widgets/admin_settings_screen.dart';
import 'package:ned_finder/features/Admin/Completed_Items/completed_items_screen.dart';
import 'package:ned_finder/features/Admin/Pending_items/pending_items_screen.dart';
import 'package:ned_finder/features/Admin/Tracking_Items/tracking_items_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/images.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart'; 

// --- 1. Define the separate table screens (for the nested navigation) ---

class LostItemsTableScreen extends StatelessWidget {
  const LostItemsTableScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(color: isDark? CustomColors.darkBackground : CustomColors.lightBackground, borderRadius: BorderRadius.circular(12)),
          child: AdminDataTables(isLostItemTable: true)
        ),
      ),
    );
  }
}

class ReportedItemsTableScreen extends StatelessWidget {
  const ReportedItemsTableScreen({super.key});
  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(color : isDark? CustomColors.darkBackground : CustomColors.lightBackground, borderRadius: BorderRadius.circular(12)),
          child: AdminDataTables(isLostItemTable: false)
        ),
      ),
    );
  }
}


// --- 2. Create a DashboardContentScreen with an internal BottomNavigationBar ---

class DashboardContentScreen extends StatefulWidget {
  const DashboardContentScreen({super.key});

  @override
  State<DashboardContentScreen> createState() => _DashboardContentScreenState();
}

class _DashboardContentScreenState extends State<DashboardContentScreen> {
  int _currentIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  final List<Widget> _tableScreens = const [
    LostItemsTableScreen(key: PageStorageKey('lostTable')),
    ReportedItemsTableScreen(key: PageStorageKey('reportedTable')),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      // Important: Use a container or the background color for the body here, 
      // NOT the main CustomColors.lightBackground, otherwise the BottomAppBar 
      // will use the main Scaffold background color.
      backgroundColor:isDark? CustomColors.darkBackground : CustomColors.lightBackground, 
      
      // The body will show the selected table screen
      body: PageStorage(
        bucket: _bucket,
        child: _tableScreens[_currentIndex],
      ),

      // The Bottom Navigation Bar for Lost/Reported items
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: CustomColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Lost Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reported Items',
          ),
        ],
      ),
    );
  }
}

// --- 3. Update the main AdminDashboardScreen to use the new content ---

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    // The original tabs are restored
    const List<String> tabs = [
      'Dashboard', 
      'Pending Items', 
      'Tracking Items', 
      'Completed Items'
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor:isDark? CustomColors.darkBackground : CustomColors.lightBackground,  // Light background for the overall page
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section: Logo, TabBar, and Log Out Button
            _buildHeader(context, tabs),
            
            // Main Content Area (Tab Views)
            Expanded(
              child: TabBarView(
                children: tabs.map((String tabName) {
                  switch (tabName){
                    case 'Dashboard':
                      // Here we place the new widget containing the internal Bottom Nav Bar
                      // This ensures only the 'Dashboard' tab has the Lost/Reported switcher
                      return const DashboardContentScreen(); 
                    case 'Pending Items':
                      // Keep the original content for other tabs
                      return PendingItemsScreen();
                    case 'Tracking Items':
                      // Keep the original content for other tabs
                      return TrackingItemsScreen();
                    default:
                      return CompletedItemsScreen();
                  }
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Header Widget (Remains the same as your original code) ---
  Widget _buildHeader(BuildContext context, List<String> tabs) {
    bool isDark = HelperFunctions.isDarkMode(context);
    return Container(
      color: isDark? CustomColors.darkBackground : CustomColors.lightBackground, // White background for the header bar
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // SeekNFind Logo and Log Out
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SeekNFind Logo/Title
                  Row(
                  children: [
                    Image.asset(CustomImages.appLogo,height: 30,),
                    const SizedBox(width: 8,),
                    Text(
                      CustomTexts.appName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                // Log Out Button
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement Log Out logic
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSettingsScreen()));
                  },
                  icon: const Icon(Icons.settings, color: CustomColors.primary),
                  label: const Text(
                    'Settings',
                    style: TextStyle(color: CustomColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Tab Bar
            Align(
              alignment: Alignment.topLeft,
              child: TabBar(
                isScrollable: true,
                tabs: tabs.map((name) => Tab(text: '  ${name}  ')).toList(),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColors.primary,
                ),
                labelColor: CustomColors.white,
                unselectedLabelColor: isDark? Colors.white : Colors.black,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}