import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ned_finder/Providers/Admin/completed_items_provider.dart';
import 'package:ned_finder/Providers/Admin/pending_claims_provider.dart';
import 'package:ned_finder/Providers/Admin/pending_items_provider.dart';
import 'package:ned_finder/Providers/Authentication/login_provider.dart';
import 'package:ned_finder/Providers/Authentication/signup_provider.dart';
import 'package:ned_finder/Providers/Home/claim_item_provider.dart';
import 'package:ned_finder/Providers/Home/home_provider.dart';
import 'package:ned_finder/Providers/Home/view_item_provider.dart';
import 'package:ned_finder/Providers/My_Items/my_items_provider.dart';
import 'package:ned_finder/Providers/Settings/profile_provider.dart';
import 'package:ned_finder/Providers/Settings/settings_provider.dart';
import 'package:ned_finder/app_startup_screen.dart';
import 'package:ned_finder/utils/theme/theme.dart';
import 'package:ned_finder/utils/theme/theme_controller.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the GetX ThemeController
    final themeController = Get.put(ThemeController());
    
    // Wrap with MultiProvider
    return MultiProvider(
      providers: [
        // Add all your providers here
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ClaimItemProvider()),
        ChangeNotifierProvider(create: (_) => ViewItemProvider()), 
        ChangeNotifierProvider(create: (_) => MyItemsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => CompletedItemsProvider()),
        ChangeNotifierProvider(create: (_) => PendingClaimsProvider()),
        ChangeNotifierProvider(create: (_) => PendingItemsProvider()),

      ],
      child: Obx(
        () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeController.themeMode,
          theme: CustomAppTheme.lightTheme,
          darkTheme: CustomAppTheme.darktheme,
          home: const AppStartupScreen(),
        ),
      ),
    );
  }
}