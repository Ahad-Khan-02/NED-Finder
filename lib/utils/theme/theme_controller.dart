import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void toggleTheme(bool isDark) async {
    _themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;

    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isDarkMode', isDark);
  }

  Future<void> loadTheme() async {
    final pref = await SharedPreferences.getInstance();
    bool savedTheme = pref.getBool('isDarkMode') ?? false;
    _themeMode.value = savedTheme ? ThemeMode.dark : ThemeMode.light;
  }
}
