import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/features/Home/view_item_screen.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/Providers/My_Items/my_items_provider.dart';

class MyItemsContent extends StatefulWidget {
  const MyItemsContent({super.key});

  @override
  State<MyItemsContent> createState() => _MyItemsContentState();
}

class _MyItemsContentState extends State<MyItemsContent> {
  @override
  void initState() {
    super.initState();
    // Initialize provider when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyItemsProvider>().initialize();
    });
  }

  void _navigateToItemDetail(BuildContext context, ItemModel item, int userId) async {
    final bool? shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ViewItemScreen(
          item: item,
          isMyItem: true,
          currentUserID: userId,
        ),
      ),
    );

    if (shouldRefresh == true && mounted) {
      debugPrint('ViewItemScreen signaled a change. Refreshing MyItemsContent...');
      context.read<MyItemsProvider>().fetchMyItems();
    }
  }

  Widget _buildContent(MyItemsProvider provider) {
    // Show error
    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.red),
            SizedBox(height: 10),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.fetchMyItems,
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    // Show loading
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show empty state
    if (provider.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              CustomTexts.noMyItems,
              style: TextStyle(fontSize: 16),
            ),
            TextButton(
              onPressed: provider.fetchMyItems,
              child: const Text(
                'Try Reloading',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      );
    }

    // Show empty filtered results
    if (provider.filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No ${provider.selectedFilter.toLowerCase()} found.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Show items list
    return Expanded(
      child: ItemCardList(
        items: provider.filteredItems,
        isMyItem: true,
        userID: provider.currentUserId!,
        onRefresh: provider.fetchMyItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyItemsProvider>(
      builder: (context, myItemsProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeaderSection(
              isMyitemsScreen: true,
              isSettingsScreen: false,
              onFilterChanged: myItemsProvider.runFilter,
            ),
            _buildContent(myItemsProvider),
          ],
        );
      },
    );
  }
}