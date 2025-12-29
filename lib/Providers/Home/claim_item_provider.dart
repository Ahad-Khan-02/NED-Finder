import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimItemProvider extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  static const int minClaimMessageLength = 10;
  
  bool _isClaiming = false;
  bool get isClaiming => _isClaiming;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  String? _successMessage;
  String? get successMessage => _successMessage;
  
  int? _currentUserId;
  int? get currentUserId => _currentUserId;
  
  // Load user ID on initialization
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getInt('user_id');
    notifyListeners();
  }
  
  // Validate form
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }
  
  // Submit claim
  Future<bool> submitClaim(ItemModel item) async {
    if (!validateForm()) {
      return false;
    }

    _isClaiming = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    // Check if user is logged in
    if (_currentUserId == null) {
      _errorMessage = 'Error: User not logged in. Cannot submit claim.';
      _isClaiming = false;
      notifyListeners();
      return false;
    }

    try {
      const endpoint = 'claim';
      
      final queryParams = {
        'item_id': item.id.toString(),
        'user_id': _currentUserId.toString(),
        'claim_message': messageController.text,
      };

      final response = await Http.postWithQueryParams(endpoint, queryParams);

      if (response != null && response['status'] == 'success') {
        _successMessage = response['message'] ?? 'Item claim submitted successfully!';
        _isClaiming = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = _extractErrorMessage(response);
        _isClaiming = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection failed. Check your network.';
      _isClaiming = false;
      notifyListeners();
      return false;
    }
  }
  
  // Extract error message from API response
  String _extractErrorMessage(Map<String, dynamic>? response) {
    String defaultError = 'Claim failed. An unknown error occurred.';
    
    if (response == null) return defaultError;
    
    if (response.containsKey('detail') && response['detail'] is List) {
      final detailList = response['detail'] as List;
      if (detailList.isNotEmpty && detailList[0].containsKey('msg')) {
        return detailList[0]['msg'] as String;
      }
    } else if (response.containsKey('message')) {
      final message = response['message'].toString();
      final parts = message.split(':');
      return parts.length > 1 ? parts[1].trim() : message;
    }
    
    return defaultError;
  }
  
  // Clear form fields
  void clearFields() {
    messageController.clear();
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
  
  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
  
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
