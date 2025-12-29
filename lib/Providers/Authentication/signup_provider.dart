import 'package:flutter/material.dart';
import 'package:ned_finder/features/Authentication/Auth%20Services/auth_services.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class SignupProvider extends ChangeNotifier {
  // Text Controllers
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  
  // State variables
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String _user = 'student';
  String get user => _user;
  
  String _department = '';
  String get department => _department;
  
  String _year = '';
  String get year => _year;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  // Setters for dropdown values
  void setUser(String value) {
    _user = value;
    notifyListeners();
  }
  
  void setDepartment(String value) {
    _department = value;
    notifyListeners();
  }
  
  void setYear(String value) {
    _year = value;
    notifyListeners();
  }
  
  // Clear all fields
  void clearFields() {
    passwordController.clear();
    emailController.clear();
    fullNameController.clear();
    _user = 'student';
    _department = '';
    _year = '';
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
  
  // Validation
  bool validateFields() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        _year.isEmpty ||
        _user.isEmpty ||
        _department.isEmpty) {
      HelperFunctions.showAlert(
        "Missing Fields",
        "Please fill all required fields.",
      );
      return false;
    }
    return true;
  }
  
  // Signup method
  Future<bool> signup() async {
    if (!validateFields()) return false;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.signup(
        role: _user,
        fullname: fullNameController.text.trim(),
        email: emailController.text.trim(),
        fieldOfStudy: _department,
        year: int.tryParse(_year) ?? 1,
        password: passwordController.text.trim(),
      );

      String msg = response["data"]?["message"] ??
          response["message"]
              .toString()
              .replaceAll("API Error (Status 400): ", "");
      msg = msg.toString().replaceAll("Value error, ", "");
      msg = msg.toString().replaceAll("value is ", "");

      HelperFunctions.showAlert(
        response["status"] == "success" ? "Success" : "Signup Failed",
        msg,
      );

      if (response["status"] == "success") {
        clearFields(); // Clear fields after successful signup
        return true;
      }
      
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      HelperFunctions.showAlert(
        "Error",
        "Failed to signup. Please try again.\nDetails: ${e.toString()}",
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    fullNameController.dispose();
    super.dispose();
  }
}