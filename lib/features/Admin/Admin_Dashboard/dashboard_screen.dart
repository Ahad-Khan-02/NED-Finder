import 'package:flutter/material.dart';
import 'package:ned_finder/features/Admin/Admin_Dashboard/widgets/admin_data_tables.dart';
import 'package:ned_finder/features/Admin/Admin_Dashboard/widgets/admin_settings_screen.dart';
import 'package:ned_finder/features/Admin/Completed_Items/completed_items_screen.dart';
import 'package:ned_finder/features/Admin/Pending_items/pending_items_screen.dart';
import 'package:ned_finder/features/Admin/Pending_Claims/pending_claims_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/images.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart'; 



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

      backgroundColor:isDark? CustomColors.darkBackground : CustomColors.lightBackground, 
      
      body: PageStorage(
        bucket: _bucket,
        child: _tableScreens[_currentIndex],
      ),

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
            label: CustomTexts.lostItemsTabletitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: CustomTexts.foundItemsTableTitle,
          ),
        ],
      ),
    );
  }
}


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    const List<String> tabs = [
      CustomTexts.dashboardTab, 
      CustomTexts.pendingItemsTab, 
      CustomTexts.pendingClaimsTab, 
      CustomTexts.completedItemsTab
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor:isDark? CustomColors.darkBackground : CustomColors.lightBackground,  // Light background for the overall page
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, tabs),
            
            Expanded(
              child: TabBarView(
                children: tabs.map((String tabName) {
                  switch (tabName){
                    case CustomTexts.dashboardTab:
                      return const DashboardContentScreen(); 
                    case CustomTexts.pendingItemsTab:
                      return PendingItemsScreen();
                    case CustomTexts.pendingClaimsTab:
                      return PendingClaimsScreen();
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


  Widget _buildHeader(BuildContext context, List<String> tabs) {
    bool isDark = HelperFunctions.isDarkMode(context);
    return Container(
      color: isDark? CustomColors.darkBackground : CustomColors.lightBackground, 
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

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
                

                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSettingsScreen()));
                  },
                  icon: const Icon(Icons.settings, color: CustomColors.primary),
                  label: const Text(
                    CustomTexts.settings,
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
                tabs: tabs.map((name) => Tab(text: '  $name  ')).toList(),
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