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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AdminDataTables(isLostItemTable: true),
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final padding = isSmallScreen ? 16.0 : 24.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AdminDataTables(isLostItemTable: false),
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
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
        selectedFontSize: isSmallScreen ? 12 : 14,
        unselectedFontSize: isSmallScreen ? 11 : 13,
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
        backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, tabs),
            Expanded(
              child: TabBarView(
                children: tabs.map((String tabName) {
                  switch (tabName) {
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;
    final isLargeScreen = size.width >= 1024;

    // Responsive sizing
    final horizontalPadding = isSmallScreen ? 16.0 : (isTablet ? 24.0 : 32.0);
    final verticalPadding = isSmallScreen ? 8.0 : 10.0;
    final logoSize = isSmallScreen ? 24.0 : 30.0;
    final titleFontSize = isSmallScreen ? 18.0 : (isTablet ? 22.0 : 24.0);
    final spacingBetweenLogoAndTitle = isSmallScreen ? 6.0 : 8.0;
    final spacingAfterHeader = isSmallScreen ? 12.0 : 16.0;

    return Container(
      color: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Row with Logo and Settings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo and App Name
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        CustomImages.appLogo,
                        height: logoSize,
                      ),
                      SizedBox(width: spacingBetweenLogoAndTitle),
                      if (!isSmallScreen || size.width > 400)
                        Flexible(
                          child: Text(
                            CustomTexts.appName,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),

                // Settings Button - Responsive
                isSmallScreen
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminSettingsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: CustomColors.primary,
                        ),
                        tooltip: CustomTexts.settings,
                      )
                    : TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminSettingsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: CustomColors.primary,
                        ),
                        label: Text(
                          CustomTexts.settings,
                          style: TextStyle(
                            color: CustomColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: isTablet ? 14 : 16,
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(height: spacingAfterHeader),

            // Tab Bar - Responsive
            Align(
              alignment: Alignment.topLeft,
              child: TabBar(
                isScrollable: true,
                tabAlignment: isLargeScreen ? TabAlignment.start : TabAlignment.start,
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                ),
                tabs: tabs.map((name) {
                  return Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8 : 12,
                        vertical: isSmallScreen ? 8 : 10,
                      ),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : (isTablet ? 13 : 14),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColors.primary,
                ),
                labelColor: CustomColors.white,
                unselectedLabelColor: isDark ? Colors.white : Colors.black,
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