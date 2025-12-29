import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/utils/http/http_client.dart';

class ViewItemProvider extends ChangeNotifier {
  // Loading states
  bool _isMarkingAsFound = false;
  bool get isMarkingAsFound => _isMarkingAsFound;
  
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  
  bool _isEditing = false;
  bool get isEditing => _isEditing;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  String? _successMessage;
  String? get successMessage => _successMessage;
  
  // Current item being viewed (can be updated after edit)
  ItemModel? _currentItem;
  ItemModel? get currentItem => _currentItem;
  
  // Initialize with item
  void setItem(ItemModel item) {
    _currentItem = item;
    notifyListeners();
  }
  
  // Mark item as found
  Future<bool> markAsFound(ItemModel item) async {
    if (item.isFound) {
      _errorMessage = 'Item already marked as found';
      notifyListeners();
      return false;
    }
    
    if (item.statusText == 'REJECTED' || item.statusText == 'PENDING') {
      _errorMessage = 'Item not approved yet';
      notifyListeners();
      return false;
    }
    
    _isMarkingAsFound = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    
    try {
      // Use PUT with data parameter (empty map)
      final response = await Http.put('items/${item.id}/mark-found', data: {});
      
      if (response['status'] == 'success') {
        _successMessage = response['message'] ?? 'Item marked as found successfully!';
        _isMarkingAsFound = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to mark item as found';
        _isMarkingAsFound = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _isMarkingAsFound = false;
      notifyListeners();
      return false;
    }
  }
  
  // Delete item
  Future<bool> deleteItem(ItemModel item) async {
    _isDeleting = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    
    try {
      final response = await Http.delete('items/${item.id}');
      
      if (response['status'] == 'success') {
        _successMessage = response['message'] ?? 'Item deleted successfully!';
        _isDeleting = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to delete item';
        _isDeleting = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _isDeleting = false;
      notifyListeners();
      return false;
    }
  }
  
  // Edit item
  Future<bool> editItem({
    required ItemModel originalItem,
    required String name,
    required String description,
    required String location,
    Uint8List? newImageBytes,
    String? newImageMimeType,
  }) async {
    _isEditing = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    
    try {
      Map<String, dynamic> response;
      
      // Check if we have a new image to upload
      if (newImageBytes != null && newImageMimeType != null) {
        // Use multipart PUT for image upload
        response = await Http.put(
          'items/${originalItem.id}',
          isMultipart: true,
          data: {
            'name': name,
            'description': description,
            'location': location,
          },
          fileBytes: newImageBytes,
          fileName: 'item_image.jpg',
          fileMimeType: newImageMimeType,
          fileFieldName: 'image',
        );
      } else {
        // Use regular JSON PUT (no image)
        response = await Http.put(
          'items/${originalItem.id}',
          data: {
            'name': name,
            'description': description,
            'location': location,
          },
        );
      }
      
      if (response['status'] == 'success') {
        _successMessage = response['message'] ?? 'Item updated successfully!';
        _isEditing = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to update item';
        _isEditing = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _isEditing = false;
      notifyListeners();
      return false;
    }
  }
  
  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
  
  // Reset state
  void reset() {
    _isMarkingAsFound = false;
    _isDeleting = false;
    _isEditing = false;
    _errorMessage = null;
    _successMessage = null;
    _currentItem = null;
    notifyListeners();
  }
}