import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/features/Home/view_item_screen.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/utils/constants/texts.dart'; 
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyItemsContent extends StatefulWidget {
  const MyItemsContent({super.key});

  @override
  State<MyItemsContent> createState() => _MyItemsContentState();
}

class _MyItemsContentState extends State<MyItemsContent> {
  List<ItemModel> items = []; 
  List<ItemModel> _filteredItems = []; 
  
  String _selectedFilter = CustomTexts.allItemsFilter; 
  bool _isLoading = true;
  String? _error;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _fetchMyItems();
  }

  // --- FILTERING LOGIC ---
  void _runFilter(String filter) {
    List<ItemModel> results = [];
    
    _selectedFilter = filter; 

    if (filter == CustomTexts.allItemsFilter) {
      // 1. Show all items
      results = items;
    } else if (filter == CustomTexts.lostItemsFilter) {
      // 2. Filter for items that are marked as Lost (isLost = true)
      results = items.where((item) => item.itemType == 'lost').toList();
    } else if (filter == CustomTexts.foundItemsFilter) {
      // 3. Filter for items that are marked as Found (isLost = false)
      results = items.where((item) => item.itemType == 'found').toList();
    } else {
      // Default to all items if filter is unknown
      results = items;
    }

    setState(() {
      _filteredItems = results;
    });
  }


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

        setState(() {
          items = fetchedItems;
          _isLoading = false;
          _runFilter(_selectedFilter); 
        });
      } else {
        throw Exception(
            responseData['message'] ?? 'Failed to retrieve your reported items.');
      }
    } catch (e) {
      setState(() {
        _error =
            'Could not load your reported items. Check the network connection or try again later.';
        _isLoading = false;
      });
    }
  }

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
      _fetchMyItems();
    }
  }


  Widget _buildContent() {
    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
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
              onPressed: _fetchMyItems,
              child: const Text('Try Reloading',style: TextStyle(color: Colors.blue),),
            )
          ],
        ),
      );
    }
    
    if (_filteredItems.isEmpty) {
      return Center(
        child: Text('No ${_selectedFilter.toLowerCase()} found.'),
      );
    }

    return Expanded(
      child: ItemCardList(
        items: _filteredItems, 
        isMyItem: true,
        userID: currentUserId!,
        onRefresh: _fetchMyItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeHeaderSection(
          isMyitemsScreen: true,
          isSettingsScreen: false,
          onFilterChanged: _runFilter, 
        ),
        
        _buildContent(),
      ],
    );
  }
}