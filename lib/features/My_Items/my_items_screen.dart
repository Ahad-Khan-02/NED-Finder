import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/view_item_screen.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/utils/constants/texts.dart'; // Ensure this is imported
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyItemsContent extends StatefulWidget {
  const MyItemsContent({super.key});

  @override
  State<MyItemsContent> createState() => _MyItemsContentState();
}

class _MyItemsContentState extends State<MyItemsContent> {
  // Master list of all user items (unchanging after fetch)
  List<ItemModel> items = []; 
  // List currently displayed to the user (changes based on filter)
  List<ItemModel> _filteredItems = []; 
  
  String _selectedFilter = CustomTexts.allItemsFilter; // Initial filter state
  bool _isLoading = true;
  String? _error;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _fetchMyItems();
  }

  // --- FILTERING LOGIC ---
  /// Filters the master list (`items`) into the displayed list (`_filteredItems`).
  void _runFilter(String filter) {
    List<ItemModel> results = [];
    
    // Update the local filter state
    _selectedFilter = filter; 

    if (filter == CustomTexts.allItemsFilter) {
      // 1. Show all items
      results = items;
    } else if (filter == CustomTexts.lostItemsFilter) {
      // 2. Filter for items that are marked as Lost (isLost = true)
      results = items.where((item) => item.itemType == 'lost').toList();
    } else if (filter == CustomTexts.foundItemsFilter) {
      // 3. Filter for items that are marked as Found (isLost = false)
      // NOTE: This assumes found items have isLost set to false
      results = items.where((item) => item.itemType == 'found').toList();
    } else {
      // Default to all items if filter is unknown
      results = items;
    }

    // Update the displayed list and re-render the UI
    setState(() {
      _filteredItems = results;
    });
  }
  // --- END FILTERING LOGIC ---

  // --- DATA FETCHING (UPDATED) ---
  Future<void> _fetchMyItems() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      setState(() {
        _error = 'User not logged in. Cannot fetch items.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      currentUserId = userId;
      _isLoading = true;
      _error = null;
    });

    try {
      final endpoint = 'my-items/$currentUserId';
      final responseData = await Http.get(endpoint);

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'] ?? responseData['data'];

        final List<ItemModel> fetchedItems =
            itemsJson.map((item) => ItemModel.fromJson(item)).toList();

        // Update State with Data
        setState(() {
          items = fetchedItems; // Update the master list
          _isLoading = false;
          // Apply the current filter to the newly fetched data
          _runFilter(_selectedFilter); 
        });
        debugPrint('Successfully loaded ${items.length} user items of userID ${currentUserId}');
      } else {
        throw Exception(
            responseData['message'] ?? 'Failed to retrieve your reported items.');
      }
    } catch (e) {
      print('🚨 Error fetching my items: $e');
      setState(() {
        _error =
            'Could not load your reported items. Check the network connection or try again later.';
        _isLoading = false;
      });
    }
  }

  // --- NAVIGATION AND REFRESH HANDLER ---
  void _navigateToItemDetail(ItemModel item) async {
    if (currentUserId == null) return;

    final bool? shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ViewItemScreen(
          item: item,
          isMyItem: true,
          currentUserID: currentUserId!,
        ),
      ),
    );

    if (shouldRefresh == true) {
      debugPrint('ViewItemScreen signaled a change. Refreshing MyItemsContent...');
      // Re-fetch items if the detail screen signals a change (e.g., item marked as found/deleted)
      _fetchMyItems();
    }
  }
  // --- END: Navigation and Refresh Handler ---


  // --- MAIN CONTENT (Handles Loading/Error/Data) ---
  Widget _buildContent() {
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
      // If the master list is empty, show the primary "no items reported" message
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
              child: const Text('Try Reloading',style: TextStyle(color: Colors.blue),),
            )
          ],
        ),
      );
    }
    
    if (_filteredItems.isEmpty) {
      // If the master list is NOT empty, but the filtered list IS empty,
      // it means the current filter yielded no results.
      return Center(
        child: Text('No ${_selectedFilter.toLowerCase()} found.'),
      );
    }

    // 4. Display Data
    return Expanded(
      // The ItemCardList now uses the _filteredItems list
      child: ItemCardList(
        items: _filteredItems, 
        isMyItem: true,
        userID: currentUserId!,
        onRefresh: _fetchMyItems,
        // NOTE: You still need to ensure your ItemCardList/individual card 
        // calls _navigateToItemDetail(item) on tap.
        // onItemTapped: _navigateToItemDetail, // Example
      ),
    );
  }

  // --- BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeHeaderSection(
          isMyitemsScreen: true,
          isSettingsScreen: false,
          // 💥 Pass the filter function to the header section
          onFilterChanged: _runFilter, 
        ),
        
        // This is where the dynamic content (Loading/Error/Data List) goes.
        _buildContent(),
      ],
    );
  }
}