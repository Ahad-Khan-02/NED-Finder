import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ned_finder/features/Authentication/Auth%20Services/auth_services.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class LoginProvider extends ChangeNotifier {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  // Login method
  Future<bool> login(BuildContext context) async {
    // Validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      HelperFunctions.showAlert('Alert', 'Please enter both email and password.');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final data = response['data'];

      if (response['status'] != 'success') {
        HelperFunctions.showAlert(
          'Login Failed',
          'Invalid Email or Password',
        );
        return false;
      }

      if (response['status'] == 'success' && data != null) {
        // Save user data
        await _saveUserData(data);
        return true;
      }
      
      return false;
    } catch (e) {
      HelperFunctions.showAlert(
        'Error',
        'An error occurred during login.\nDetails: $e',
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('user_id', data['user_id']);
    await prefs.setString('email', data['email']);
    await prefs.setString('role', data['role']);
    await prefs.setString('fullname', data['fullname']);
  }

  // Get user role from response
  String? getUserRole(Map<String, dynamic>? response) {
    return response?['data']?['role'];
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}