import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:ned_finder/features/Authentication/Login/login_screen.dart';
import 'package:ned_finder/features/Settings/Profile/profile_screen.dart';
import 'package:ned_finder/features/Settings/widgets/custom_settings_tile.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// NOTE: When using this inside HomeScreen's _buildMainContent, 
// ensure the necessary constant files (colors, texts, helpers) are accessible.

class SettingsContent extends StatefulWidget {
  // Renamed to SettingsContent to imply it's the body content, not a full screen
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  // State for the Dark Mode toggle
  bool _isDarkMode = false; 


  @override
  Widget build(BuildContext context) {
    // Determine card and text colors based on the current theme
    final themeController = Get.find<ThemeController>();
    final bool isDark = HelperFunctions.isDarkMode(context);
    final Color cardColor = isDark ? CustomColors.darkContainer : CustomColors.lightContainer;
    final Color textColor = isDark ? Colors.white : CustomColors.darkerGrey;

    return SingleChildScrollView(
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

          // --- SeekNFInd Android Tile ---
          SettingsTile(
            icon: Icons.person,
            title: 'Profile',
            subtitle: 'View Profile',
            cardColor: cardColor,
            textColor: textColor,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen()));
            },
          ),
          const SizedBox(height: 16),

          // --- FAQs Tile ---
          SettingsTile(
            icon: Icons.question_mark_rounded,
            title: 'FAQs',
            subtitle: 'Frequently Asked Questions',
            cardColor: cardColor,
            textColor: textColor,
            onTap: () {
              // TODO: Implement navigation to the FAQs screen/page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigating to FAQs...')),
              );
            },
          ),
          const SizedBox(height: 16),

          // --- About SeekNFInd Tile ---
          SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            cardColor: cardColor,
            textColor: textColor,
            onTap: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

