import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ned_finder/Providers/Settings/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:ned_finder/Providers/Authentication/login_provider.dart';
import 'package:ned_finder/Providers/Home/home_provider.dart';
import 'package:ned_finder/features/Authentication/Login/login_screen.dart';
import 'package:ned_finder/features/Settings/Profile/profile_screen.dart';
import 'package:ned_finder/features/Settings/widgets/custom_settings_tile.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/theme/theme_controller.dart';

class SettingsContent extends StatelessWidget {
  final int userID;

  const SettingsContent({super.key, required this.userID});

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    // Use settings provider to logout
    final settingsProvider = context.read<SettingsProvider>();
    final success = await settingsProvider.logout();

    if (!context.mounted) return;

    if (success) {
      // Clear other providers
      context.read<LoginProvider>().clearFields();
      context.read<HomeProvider>().onDrawerItemSelected(0);

      // Navigate to login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (_) => false,
      );
    } else {
      // Show error if logout failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(settingsProvider.errorMessage ?? 'Failed to logout'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = HelperFunctions.isDarkMode(context);
    final Color cardColor = isDark 
        ? CustomColors.darkContainer 
        : CustomColors.lightContainer;
    final Color textColor = isDark ? Colors.white : CustomColors.darkerGrey;

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dark Mode Toggle
              SettingsTile(
                icon: Icons.dark_mode,
                title: CustomTexts.darkMode,
                subtitle: themeController.isDarkMode 
                    ? CustomTexts.darkModeOn 
                    : CustomTexts.darkModeOff,
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

              // Profile
              SettingsTile(
                icon: Icons.person,
                title: CustomTexts.profile,
                subtitle: CustomTexts.viweProfile,
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(userId: userID),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Logout
              SettingsTile(
                icon: Icons.logout,
                title: CustomTexts.logout,
                cardColor: cardColor,
                textColor: textColor,
                trailing: settingsProvider.isLoggingOut
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                onTap: settingsProvider.isLoggingOut
                    ? null
                    : () => _handleLogout(context),
              ),
            ],
          ),
        );
      },
    );
  }
}