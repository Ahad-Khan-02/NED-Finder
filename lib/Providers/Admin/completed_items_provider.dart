import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Completed_items/completed_items_model.dart';
import 'package:ned_finder/utils/http/http_client.dart' show Http;

class CompletedItemsProvider extends ChangeNotifier {
  List<CompletedItemModel> _completedItems = [];
  bool _isLoading = true;
  String? _error;

  List<CompletedItemModel> get completedItems => _completedItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CompletedItemsProvider() {
    fetchCompletedItems();
  }

  Future<void> fetchCompletedItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final responseData = await Http.get('items/approved');

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'] ?? [];

        final List<CompletedItemModel> fetchedItems = itemsJson
            .map((item) => CompletedItemModel.fromJson(item))
            .toList();

        // Filter items that are actually marked as found
        _completedItems = fetchedItems.where((item) => item.isFound).toList();
        _error = null;
      } else {
        _error = responseData['message'] ?? 'Failed to retrieve approved items.';
      }
    } catch (e) {
      _error = 'Error fetching data: ${e.toString()}';
      debugPrint('API Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}