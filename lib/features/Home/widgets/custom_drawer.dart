import 'package:flutter/material.dart';
import 'package:ned_finder/Models/User/user_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/images.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';
 // Import the new service

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.userId, // Requires a user ID to fetch data
  });

  final int selectedIndex;
  // Callback function to inform the parent widget (Home Screen) about the selection
  final Function(int) onItemSelected;
  final int userId; // The ID of the currently logged-in user

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // The Future that will hold the user data
  late Future<UserModel> _userFuture;

  @override
  void initState() {
    super.initState();
    // Start fetching user data using the dedicated UserService
    _userFuture = fetchUser(widget.userId);
  }

  static Future<UserModel> fetchUser(int userId) async {
    // Construct the endpoint path: e.g., 'users/11'
    final endpoint = 'users/$userId'; 
    
    // Use the static Http client to make the GET request
    final result = await Http.get(endpoint);

    if (result['status'] == 'success' && result.containsKey('data')) {
      // Map the 'data' part of the response to the UserModel
      return UserModel.fromJson(result['data'] as Map<String, dynamic>);
    } else {
      // Throw an exception with the error message from the API or a default message
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
          // App Logo/Title Section (Drawer Header)
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 16.0, bottom: 20.0),
            child: Row(
              children: [
                // Assuming CustomImages.appLogo is correctly defined elsewhere
                const Image(image: AssetImage(CustomImages.appLogo), height: 50, width: 50),

                Text(
                  CustomTexts.appName,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    // Ensure color adapts to dark mode if not handled by Theme
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

          // User Profile Section (Uses FutureBuilder to display fetched data)
          FutureBuilder<UserModel>(
            future: _userFuture,
            builder: (context, snapshot) {
              String name = 'Loading...';
              String emailOrError = 'Fetching data...';
              bool hasError = false;
              
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Default loading state
              } else if (snapshot.hasError) {
                // If the UserService threw an exception (e.g., failed to parse or API returned error)
                name = 'Guest User';
                emailOrError = snapshot.error.toString().replaceFirst('Exception: ', '');
                hasError = true;
                // Log the error in a real app: print('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // Data successfully fetched
                final user = snapshot.data!;
                name = user.fullname;
                emailOrError = user.email; // Displaying email
              } else {
                 // Should generally not happen if future is initialized correctly
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

  // Helper function to build a single navigation drawer item
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
        widget.onItemSelected(index); // Call the callback function
        Navigator.pop(context); // Close the drawer
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