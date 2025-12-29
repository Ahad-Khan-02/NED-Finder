import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  // State variables
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  
  List<ItemModel> _items = [];
  List<ItemModel> get items => List.unmodifiable(_items);
  
  List<ItemModel> _filteredItems = [];
  List<ItemModel> get filteredItems => List.unmodifiable(_filteredItems);
  
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  int? _currentUserId;
  int? get currentUserId => _currentUserId;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  // Initialize - call this when screen loads
  Future<void> initialize() async {
    await _loadUserId();
    await fetchItems();
  }
  
  // Load user ID from SharedPreferences
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getInt('user_id');
    notifyListeners();
  }
  
  // Search filter
  void runSearchFilter(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredItems = _items;
    } else {
      final searchLower = query.toLowerCase();
      _filteredItems = _items.where((item) {
        final nameLower = item.name.toLowerCase();
        final descriptionLower = item.description.toLowerCase();
        return nameLower.contains(searchLower) || descriptionLower.contains(searchLower);
      }).toList();
    }
    
    notifyListeners();
  }
  
  // Fetch items from API
  Future<void> fetchItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final responseData = await Http.get('items/approved');

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'];

        final List<ItemModel> fetchedItems = itemsJson
            .map((item) => ItemModel.fromJson(item))
            .toList();

        // Filter only not found items
        final List<ItemModel> notFoundItems = fetchedItems
            .where((item) => !item.isFound)
            .toList();

        _items = notFoundItems;
        _filteredItems = notFoundItems;
      } else {
        _errorMessage = 'Failed to retrieve items (Status: ${responseData['status']})';
      }
    } catch (e) {
      _errorMessage = 'Error fetching items: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Change selected drawer item
  void onDrawerItemSelected(int index) {
    _selectedIndex = index;
    notifyListeners();
    
    // Refresh items when going back to home
    if (index == 0) {
      fetchItems();
    }
  }
  
  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredItems = _items;
    notifyListeners();
  }
  
  // Refresh items (pull to refresh)
  Future<void> refreshItems() async {
    await fetchItems();
  }
}