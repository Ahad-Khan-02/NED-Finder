import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  // Logout function
  Future<bool> logout() async {
    _isLoggingOut = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Clear all user data
      await prefs.clear();
      
      // Or clear specific keys
      // await prefs.remove('isLoggedIn');
      // await prefs.remove('user_id');
      // await prefs.remove('email');
      // await prefs.remove('role');
      // await prefs.remove('fullname');
      
      _isLoggingOut = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to logout: $e';
      _isLoggingOut = false;
      notifyListeners();
      return false;
    }
  }
  
  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}