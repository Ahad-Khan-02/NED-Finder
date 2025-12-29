import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart';
import 'package:ned_finder/utils/http/http_client.dart';

class PendingItemsProvider with ChangeNotifier {
  List<PendingItemModel> _pendingItems = [];
  bool _isLoading = false;
  String? _error;

  List<PendingItemModel> get pendingItems => _pendingItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetches pending items from the backend API
  Future<void> fetchPendingItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final responseData = await Http.get('items/pending');

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'] ?? [];

        _pendingItems = itemsJson
            .map((item) => PendingItemModel.fromJson(item))
            .toList();
        
        debugPrint('Successfully loaded ${_pendingItems.length} pending items.');
      } else {
        _error = responseData['message'] ?? 'Failed to retrieve pending items.';
      }
    } catch (e) {
      _error = 'Error fetching data: ${e.toString()}';
      debugPrint('API Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears error state manually if needed
  void clearError() {
    _error = null;
    notifyListeners();
  }
}