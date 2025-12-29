import 'package:flutter/material.dart';
import 'package:ned_finder/Models/User/user_item_stat_model.dart';
import 'package:ned_finder/Models/User/user_model.dart';
import 'package:ned_finder/utils/http/http_client.dart';

class ProfileProvider extends ChangeNotifier {
  // User data
  UserModel? _user;
  UserModel? get user => _user;
  
  // Item statistics
  UserItemStatsModel? _itemStats;
  UserItemStatsModel? get itemStats => _itemStats;
  
  // Loading states
  bool _isLoadingUser = true;
  bool get isLoadingUser => _isLoadingUser;
  
  bool _isLoadingStats = true;
  bool get isLoadingStats => _isLoadingStats;
  
  // Error states
  String? _userError;
  String? get userError => _userError;
  
  String? _statsError;
  String? get statsError => _statsError;
  
  // Current user ID
  int? _currentUserId;
  int? get currentUserId => _currentUserId;
  
  // Initialize with user ID
  Future<void> initialize(int userId) async {
    _currentUserId = userId;
    await Future.wait([
      fetchUser(userId),
      fetchItemStats(userId),
    ]);
  }
  
  // Fetch user profile
  Future<void> fetchUser(int userId) async {
    _isLoadingUser = true;
    _userError = null;
    notifyListeners();
    
    try {
      final endpoint = 'users/$userId';
      final result = await Http.get(endpoint);

      if (result['status'] == 'success' && result.containsKey('data')) {
        _user = UserModel.fromJson(result['data'] as Map<String, dynamic>);
      } else {
        _userError = result['message'] ?? 'Failed to load user profile.';
      }
    } catch (e) {
      _userError = 'Error loading profile: $e';
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }
  
  // Fetch item statistics
  Future<void> fetchItemStats(int userId) async {
    _isLoadingStats = true;
    _statsError = null;
    notifyListeners();
    
    try {
      final endpoint = 'my-items/$userId';
      final result = await Http.get(endpoint);

      if (result['status'] == 'success' && result.containsKey('data')) {
        final data = result['data'] as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>;

        int foundCount = 0;
        int missingCount = 0;

        for (var item in items) {
          if (item['found'] == true) {
            foundCount++;
          } else {
            missingCount++;
          }
        }

        _itemStats = UserItemStatsModel(
          missingItems: missingCount,
          foundItems: foundCount,
        );
      } else {
        _statsError = result['message'] ?? 'Failed to load item statistics.';
      }
    } catch (e) {
      _statsError = 'Error loading statistics: $e';
    } finally {
      _isLoadingStats = false;
      notifyListeners();
    }
  }
  
  // Refresh all data
  Future<void> refresh() async {
    if (_currentUserId != null) {
      await initialize(_currentUserId!);
    }
  }
  
  // Clear data
  void clear() {
    _user = null;
    _itemStats = null;
    _userError = null;
    _statsError = null;
    _isLoadingUser = true;
    _isLoadingStats = true;
    _currentUserId = null;
    notifyListeners();
  }
  
  // Getters for convenience
  String get userName => _user?.fullname ?? 'Guest';
  String get userRole => _user?.fieldOfStudy ?? 'Not available';
  String get userEmail => _user?.email ?? 'Not available';
  int get missingItemsCount => _itemStats?.missingItems ?? 0;
  int get foundItemsCount => _itemStats?.foundItems ?? 0;
  int get totalItems => missingItemsCount + foundItemsCount;
}