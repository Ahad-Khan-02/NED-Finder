import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/images.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.userName,
    required this.userRole,
  });

  final int selectedIndex;
  // Callback function to inform the parent widget (Home Screen) about the selection
  final Function(int) onItemSelected;
  
  final String userRole;
  
  final String userName;

  @override
  Widget build(BuildContext context) {

    final bool isDark = HelperFunctions.isDarkMode(context);


    return Drawer(
      backgroundColor: isDark? CustomColors.darkBackground :CustomColors.lightBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo/Title Section (Drawer Header)
          const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 16.0, bottom: 20.0),
            child: Row(
              children: [
                Image(image: AssetImage(CustomImages.appLogo), height: 50, width: 50),

                Text(
                  CustomTexts.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ),

          const SizedBox(height: 20),

          // Navigation Items
          _buildDrawerItem(
              icon: Icons.home, label: CustomTexts.home, index: 0, context: context),
          _buildDrawerItem(
              icon: Icons.list_alt, label: CustomTexts.myItems, index: 1, context: context),
          _buildDrawerItem(
              icon: Icons.settings, label: CustomTexts.settings, index: 2, context: context),

          const Spacer(),

          // User Profile Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/iamge.png'),

                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          userName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          userRole,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build a single navigation drawer item
  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final bool isSelected = selectedIndex == index;
    final bool isDark = HelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: () {
        onItemSelected(index); // Call the callback function
        Navigator.pop(context); // Close the drawer
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : isDark? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : isDark? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}