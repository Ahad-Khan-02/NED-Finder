import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ned_finder/app_startup_screen.dart';
import 'package:ned_finder/utils/theme/theme.dart';
import 'package:ned_finder/utils/theme/theme_controller.dart'; // 🔥 Import the new controller

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ThemeController
    final themeController = Get.put(ThemeController());
    // Use Obx to rebuild GetMaterialApp when themeMode changes
    return Obx(
      () => GetMaterialApp(
        // 🔥 Use the reactive themeMode from the controller
        themeMode: themeController.themeMode, 
        theme: CustomAppTheme.lightTheme,
        darkTheme: CustomAppTheme.darktheme,
        home: const AppStartupScreen(),
      ),
    );
  }
}