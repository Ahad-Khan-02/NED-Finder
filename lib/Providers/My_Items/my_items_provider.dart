import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyItemsProvider extends ChangeNotifier {
  // State variables
  List<ItemModel> _items = [];
  List<ItemModel> get items => List.unmodifiable(_items);
  
  List<ItemModel> _filteredItems = [];
  List<ItemModel> get filteredItems => List.unmodifiable(_filteredItems);
  
  String _selectedFilter = CustomTexts.allItemsFilter;
  String get selectedFilter => _selectedFilter;
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  int? _currentUserId;
  int? get currentUserId => _currentUserId;
  
  // Initialize - load user ID and fetch items
  Future<void> initialize() async {
    await _loadUserId();
    await fetchMyItems();
  }
  
  // Load user ID from SharedPreferences
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getInt('user_id');
    notifyListeners();
  }
  
  // Fetch user's items from API
  Future<void> fetchMyItems() async {
    if (_currentUserId == null) {
      _error = 'User not logged in. Cannot fetch items.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final endpoint = 'my-items/$_currentUserId';
      final responseData = await Http.get(endpoint);

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'] ?? responseData['data'];

        final List<ItemModel> fetchedItems =
            itemsJson.map((item) => ItemModel.fromJson(item)).toList();

        _items = fetchedItems;
        _isLoading = false;
        runFilter(_selectedFilter); // Apply current filter
      } else {
        _error = responseData['message'] ?? 'Failed to retrieve your reported items.';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Could not load your reported items. Check the network connection or try again later.';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Filter items based on selection
  void runFilter(String filter) {
    _selectedFilter = filter;

    if (filter == CustomTexts.allItemsFilter) {
      // Show all items
      _filteredItems = _items;
    } else if (filter == CustomTexts.lostItemsFilter) {
      // Filter for lost items
      _filteredItems = _items.where((item) => item.itemType == 'lost').toList();
    } else if (filter == CustomTexts.foundItemsFilter) {
      // Filter for found items
      _filteredItems = _items.where((item) => item.itemType == 'found').toList();
    } else {
      // Default to all items
      _filteredItems = _items;
    }

    notifyListeners();
  }
  
  // Refresh items (pull to refresh)
  Future<void> refreshItems() async {
    await fetchMyItems();
  }
  
  // Clear all data
  void clear() {
    _items = [];
    _filteredItems = [];
    _selectedFilter = CustomTexts.allItemsFilter;
    _error = null;
    _isLoading = true;
    notifyListeners();
  }
}
