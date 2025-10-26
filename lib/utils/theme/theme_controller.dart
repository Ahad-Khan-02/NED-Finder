import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Use Rx<ThemeMode> to make it observable (reactive)
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  // Helper to check if the current theme is Dark
  bool get isDarkMode {
    // Check if the system is dark, or if the user explicitly set dark mode
    if (_themeMode.value == ThemeMode.system) {
      // Use Get.context for easy access to MediaQuery/Brightness
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  // Method to toggle the theme
  void toggleTheme(bool value) {
    _themeMode.value = value ? ThemeMode.dark : ThemeMode.light;
    
    // Optional: Use GetX to update the theme instantly (simpler than setState on MaterialApp)
    // Get.changeThemeMode(_themeMode.value);
    
    // In a real app, you would also save 'value' (true/false) to local storage (like GetStorage)
  }

  // Use this for initial state in SettingsContent
  static bool getInitialDarkModeStatus(BuildContext context) {
    // This safely reads the current status without relying on an InheritedWidget 
    // being fully built in initState. Use the GetX context access helper.
    return Get.isPlatformDarkMode;
  }

}