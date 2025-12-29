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


class AdminSettingsScreen extends StatefulWidget {

  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<AdminSettingsScreen> {

  bool _isDarkMode = false; 


  @override
  Widget build(BuildContext context) {

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

            SettingsTile(
              icon: Icons.dark_mode,
              title: CustomTexts.darkMode,
              subtitle: _isDarkMode ? CustomTexts.darkModeOn : CustomTexts.darkModeOff,
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
         

            SettingsTile(
              icon: Icons.logout,
              title: CustomTexts.logout,
              cardColor: cardColor,
              textColor: textColor,
              onTap: () async {
                // 1. Show confirmation dialog
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                // 2. Check user response and context validity
                if (confirm != true || !context.mounted) return;

                // 3. Clear local storage
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                if (!context.mounted) return;

                // 4. Navigate back to Login Screen
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

