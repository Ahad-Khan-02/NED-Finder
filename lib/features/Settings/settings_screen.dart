import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:ned_finder/features/Authentication/Login/login_screen.dart';
import 'package:ned_finder/features/Settings/Profile/profile_screen.dart';
import 'package:ned_finder/features/Settings/widgets/custom_settings_tile.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsContent extends StatefulWidget {
  final int userID;

  const SettingsContent({super.key,required this.userID});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = HelperFunctions.isDarkMode(context);
    final Color cardColor = isDark ? CustomColors.darkContainer : CustomColors.lightContainer;
    final Color textColor = isDark ? Colors.white : CustomColors.darkerGrey;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsTile(
            icon: Icons.dark_mode,
            title: CustomTexts.darkMode,
            subtitle: themeController.isDarkMode ? CustomTexts.darkModeOn : CustomTexts.darkModeOff,
            cardColor: cardColor,
            textColor: textColor,
            trailing: Switch(
              value: themeController.isDarkMode,
              onChanged: (value) {
                themeController.toggleTheme(value);
              },
              activeColor: CustomColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          SettingsTile(
            icon: Icons.person,
            title: CustomTexts.profile,
            subtitle: CustomTexts.viweProfile,
            cardColor: cardColor,
            textColor: textColor,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(userId: widget.userID,)));
            },
          ),
          const SizedBox(height: 16),

          SettingsTile(
            icon: Icons.logout,
            title: CustomTexts.logout,
            cardColor: cardColor,
            textColor: textColor,
            onTap: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

