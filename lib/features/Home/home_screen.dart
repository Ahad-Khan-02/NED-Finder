import 'package:flutter/material.dart';
import 'package:ned_finder/Providers/Home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:ned_finder/features/Home/widgets/custom_drawer.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/features/My_Items/my_items_screen.dart';
import 'package:ned_finder/features/Settings/settings_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize provider data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().initialize();
    });
  }

  Widget _buildMainContent(HomeProvider provider) {
    if (provider.isLoading || provider.currentUserId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${provider.errorMessage}',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.fetchItems,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    switch (provider.selectedIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeaderSection(
              isSettingsScreen: false,
              onSearchChanged: provider.runSearchFilter,
            ),
            provider.filteredItems.isEmpty
                ? const Center(child: Text("No items found."))
                : Expanded(
                    child: ItemCardList(
                      items: provider.filteredItems,
                      isMyItem: false,
                      userID: provider.currentUserId!,
                      onRefresh: provider.fetchItems,
                    ),
                  ),
          ],
        );
      case 1:
        return const MyItemsContent();

      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeaderSection(isSettingsScreen: true),
            SettingsContent(userID: provider.currentUserId!),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);

    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        // Show loading for initial load
        if (homeProvider.currentUserId == null && homeProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: isDark
              ? CustomColors.darkBackground
              : CustomColors.lightBackground,
          appBar: AppBar(
            title: const Text(
              CustomTexts.appName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: isDark
                ? CustomColors.darkBackground
                : CustomColors.lightBackground,
            elevation: 0,
            foregroundColor: isDark ? Colors.white : Colors.black,
          ),
          drawer: CustomDrawer(
            selectedIndex: homeProvider.selectedIndex,
            onItemSelected: homeProvider.onDrawerItemSelected,
            userId: homeProvider.currentUserId!,
          ),
          body: _buildMainContent(homeProvider),
        );
      },
    );
  }
}