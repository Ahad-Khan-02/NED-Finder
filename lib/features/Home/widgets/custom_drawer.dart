import 'package:flutter/material.dart';
import 'package:ned_finder/Models/User/user_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/images.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';


class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.userId, 
  });

  final int selectedIndex;
  final Function(int) onItemSelected;
  final int userId; 

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Future<UserModel> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser(widget.userId);
  }

  static Future<UserModel> fetchUser(int userId) async {
    final endpoint = 'users/$userId'; 
    
    final result = await Http.get(endpoint);

    if (result['status'] == 'success' && result.containsKey('data')) {
      return UserModel.fromJson(result['data'] as Map<String, dynamic>);
    } else {
      throw Exception(result['message'] ?? 'Failed to load user data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);

    return Drawer(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo/Title Section 
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 16.0, bottom: 20.0),
            child: Row(
              children: [
                const Image(image: AssetImage(CustomImages.appLogo), height: 50, width: 50),
                Text(
                  CustomTexts.appName,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black, 
                  ),
                ),
              ],
            ),
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
          FutureBuilder<UserModel>(
            future: _userFuture,
            builder: (context, snapshot) {
              String name = 'Loading...';
              String emailOrError = 'Fetching data...';
              bool hasError = false;
              
              if (snapshot.connectionState == ConnectionState.waiting) {
              } else if (snapshot.hasError) {
                name = 'Guest User';
                emailOrError = snapshot.error.toString().replaceFirst('Exception: ', '');
                hasError = true;
              } else if (snapshot.hasData) {
                final user = snapshot.data!;
                name = user.fullname;
                emailOrError = user.email; 
              } else {
                name = 'Unknown User';
                emailOrError = 'Unknown state';
              }

              return Padding(
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
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: hasError ? Colors.red : (isDark ? Colors.white : Colors.black),
                              ),
                            ),
                            Text(
                              emailOrError,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontSize: 12, 
                                  color: hasError ? Colors.red.shade400 : (isDark ? Colors.white70 : Colors.black54)
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final bool isSelected = widget.selectedIndex == index;
    final bool isDark = HelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: () {
        widget.onItemSelected(index); 
        Navigator.pop(context); 
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? Colors.blue.shade900 : Colors.blue.shade100) 
              : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : isDark ? Colors.white70 : Colors.black87,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}