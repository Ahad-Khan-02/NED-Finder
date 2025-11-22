import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:ned_finder/features/Authentication/Login/login_screen.dart';
import 'package:ned_finder/features/Settings/widgets/custom_settings_tile.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// NOTE: When using this inside HomeScreen's _buildMainContent, 
// ensure the necessary constant files (colors, texts, helpers) are accessible.

class AdminSettingsScreen extends StatefulWidget {
  // Renamed to SettingsContent to imply it's the body content, not a full screen
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<AdminSettingsScreen> {
  // State for the Dark Mode toggle
  bool _isDarkMode = false; 


  @override
  Widget build(BuildContext context) {
    // Determine card and text colors based on the current theme
    final themeController = Get.find<ThemeController>();
    final bool isDark = HelperFunctions.isDarkMode(context);
    final Color cardColor = isDark ? CustomColors.darkContainer : CustomColors.lightContainer;
    final Color textColor = isDark ? Colors.white : CustomColors.darkerGrey;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          CustomTexts.settings,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark? CustomColors.darkBackground : CustomColors.lightBackground,
        elevation: 0,
        foregroundColor: isDark? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Dark Mode Tile ---
            SettingsTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: _isDarkMode ? 'Dark Mode Is On' : 'Dark Mode Is Off',
              cardColor: cardColor,
              textColor: textColor,
              trailing: Switch(
                value: themeController.isDarkMode,
                onChanged: (value) {
                  themeController.toggleTheme(value);
                  setState(() {
                    _isDarkMode = value;
                  });
                },
                activeColor: CustomColors.primary,
              ),
            ),
            const SizedBox(height: 16),
         
            // --- About SeekNFInd Tile ---
            SettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              cardColor: cardColor,
              textColor: textColor,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

