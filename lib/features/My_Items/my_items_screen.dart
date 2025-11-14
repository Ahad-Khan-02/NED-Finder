import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Renamed to content to match the embedding style (like SettingsContent)
class MyItemsContent extends StatefulWidget {
  const MyItemsContent({super.key});

  @override
  State<MyItemsContent> createState() => _MyItemsContentState();
}

class _MyItemsContentState extends State<MyItemsContent> {
  List<ItemModel> items = []; // List to store fetched items
  bool _isLoading = true;
  String? _error;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    // Start fetching data immediately when the content loads
    _fetchMyItems();
  }

  // --- DATA FETCHING ---
  Future<void> _fetchMyItems() async {
    // 1. Get User ID from SharedPreferences
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
      // 2. API Call using the user ID
      final endpoint = 'my-items/$currentUserId';
      final responseData = await Http.get(endpoint);

      // 3. Check Response and Parse Data
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        // Assuming 'data' contains the list directly, or under an 'items' key
        final List itemsJson = responseData['data']['items'] ?? responseData['data'];

        final List<ItemModel> fetchedItems =
            itemsJson.map((item) => ItemModel.fromJson(item)).toList();

        // 4. Update State with Data
        setState(() {
          items = fetchedItems;
          _isLoading = false;
        });
        debugPrint('Successfully loaded ${items.length} user items of userID ${currentUserId}');
      } else {
        throw Exception(
            responseData['message'] ?? 'Failed to retrieve your reported items.');
      }
    } catch (e) {
      // 5. Handle Error State
      print('🚨 Error fetching my items: $e');
      setState(() {
        _error =
            'Could not load your reported items. Check the network connection or try again later.';
        _isLoading = false;
      });
    }
  }

  // --- MAIN CONTENT (Handles Loading/Error/Data) ---
  Widget _buildContent() {
    // 1. Check for Errors
    if (_error != null) {
      return Center(child: Text(_error!));
    }

    // 2. Check for Loading
    if (_isLoading) {
      // Use a Simple Loading Indicator centered in a container that fills the height
      return const Center(child: CircularProgressIndicator());
    }

    // 3. Check for Empty Data
    if (items.isEmpty) {
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

    // 4. Display Data
    // We wrap ItemCardList in Expanded to allow it to fill the remaining space
    return Expanded(
      child: ItemCardList(items: items,isMyItem: true,),
    );
  }

  // --- BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    // The structure needs to be a Column containing the header and the main content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // HomeHeaderSection remains the same, but we set isMyitemsScreen to true.
      children: [
        const HomeHeaderSection(isMyitemsScreen: true, isSettingsScreen: false),
        
        // This is where the dynamic content (Loading/Error/Data List) goes.
        // It must be wrapped in Expanded inside the outer Column.
        _buildContent(),
      ],
    );
  }
}