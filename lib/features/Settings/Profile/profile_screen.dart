import 'package:flutter/material.dart';
import 'package:ned_finder/Models/User/user_item_stat_model.dart';
// Note: Assuming these paths are correct for your project structure
import 'package:ned_finder/Models/User/user_model.dart'; 
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';




// 1. Convert to StatefulWidget for better data management 
class ProfileScreen extends StatefulWidget {
  // Required: The ID of the user whose profile should be displayed
  final int userId; 
  
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Future to hold the result of the API call for user profile
  late Future<UserModel> _userProfileFuture;

  // Future to hold the result of the API call for user item stats
  late Future<UserItemStatsModel> _itemStatsFuture;

  // --- Data Fetching Methods ---

  // Fetches User Model (Kept static inside State class as per user's provided pattern)
  static Future<UserModel> fetchUser(int userId) async {
    final endpoint = 'users/$userId'; 
    final result = await Http.get(endpoint);

    if (result['status'] == 'success' && result.containsKey('data')) {
      return UserModel.fromJson(result['data'] as Map<String, dynamic>);
    } else {
      throw Exception(result['message'] ?? 'Failed to load user profile.');
    }
  }

  // [NEW] Fetches item counts based on the response structure
  static Future<UserItemStatsModel> fetchItemStats(int userId) async {
    final endpoint = 'my-items/$userId'; 
    final result = await Http.get(endpoint);

    if (result['status'] == 'success' && result.containsKey('data')) {
      final data = result['data'] as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;

      int foundCount = 0;
      int missingCount = 0;

      for (var item in items) {
        // Calculate counts based on the 'found' boolean field as requested
        if (item['found'] == true) {
          foundCount++;
        } else {
          missingCount++;
        }
      }

      return UserItemStatsModel(
        missingItems: missingCount,
        foundItems: foundCount,
      );
    } else {
      throw Exception(result['message'] ?? 'Failed to load item statistics.');
    }
  }

  @override
  void initState() {
    super.initState();
    // Start fetching the user profile data
    _userProfileFuture = fetchUser(widget.userId);
    // Start fetching the item statistics data
    _itemStatsFuture = fetchItemStats(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final Color cardColor = isDark ? CustomColors.dark : CustomColors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Row (Profile Title and Actions) ---
            const _ProfileHeader(),
            const SizedBox(height: 32),
            
            // --- Main Profile Info Section (Uses FutureBuilder) ---
            FutureBuilder<UserModel>(
              future: _userProfileFuture,
              builder: (context, snapshot) {
                // Default placeholders for loading state
                String userName = 'Loading Name...';
                String userRole = 'Loading Role...';
                String userEmail = 'Loading Email...';
                bool isError = false;

                // Handle data state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Handled by placeholders
                } else if (snapshot.hasError) {
                  userName = 'Error';
                  userRole = 'Profile Load Failed';
                  userEmail = snapshot.error.toString().replaceFirst('Exception: ', '');
                  isError = true;
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  userName = user.fullname;
                  userRole = user.fieldOfStudy!;
                  userEmail = user.email;
                } else {
                  userName = 'Guest';
                  userRole = 'Login required';
                  userEmail = 'Not available';
                }

                return _buildUserProfileSection(
                  userName: userName,
                  userRole: userRole,
                  userEmail: userEmail,
                  isError: isError,
                  userProfileFuture: _userProfileFuture, // Pass the future for the loading spinner
                );
              },
            ),

            const SizedBox(height: 40),
            
            // --- Stats Cards (Missing/Found Items - Now uses FutureBuilder for Item Stats) ---
            FutureBuilder<UserItemStatsModel>(
              future: _itemStatsFuture,
              builder: (context, snapshot) {
                // Default stats
                int missingCount = 0;
                int foundCount = 0;
                bool isStatsError = false;
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Keep default 0s for missing/found, but show loading indicator if desired
                } else if (snapshot.hasError) {
                  isStatsError = true;
                } else if (snapshot.hasData) {
                  missingCount = snapshot.data!.missingItems;
                  foundCount = snapshot.data!.foundItems;
                }
                
                return Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.help_outline,
                        label: isStatsError ? 'Error' : 'Missing Item',
                        count: isStatsError ? 0 : missingCount,
                        cardColor: cardColor,
                        isError: isStatsError,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle_outline,
                        label: isStatsError ? 'Error' : 'Found Item',
                        count: isStatsError ? 0 : foundCount,
                        cardColor: cardColor,
                        isError: isStatsError,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Extracted method to build the main profile detail section
  Widget _buildUserProfileSection({
    required String userName,
    required String userRole,
    required String userEmail,
    required Future<UserModel> userProfileFuture,
    bool isError = false,
  }) {
    // Determine the color for the details based on the state
    final Color detailColor = isError ? Colors.red : Theme.of(context).textTheme.bodyMedium!.color!;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Avatar or Loading Spinner
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isError ? Colors.red.shade400 : CustomColors.primary.withOpacity(0.8),
          ),
          child: FutureBuilder(
            future: userProfileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              // Icon is shown once loading is complete or error occurred
              return const Icon(Icons.person, size: 70, color: Colors.white);
            },
          ),
        ),
        const SizedBox(width: 24),

        // User Details (Vertically Aligned)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: detailColor,
                ),
              ),
              
              // Role/Course (Using Role from API)
              _ProfileDetailRow(
                icon: Icons.school_outlined,
                text: userRole,
                color: detailColor,
              ),
              const SizedBox(height: 4),
              
              // Email/Location (Using Email from API)
              _ProfileDetailRow(
                icon: Icons.alternate_email,
                text: userEmail,
                color: detailColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// Extracted Private Widgets (Minor updates to accept color)
// -------------------------------------------------------------

// Helper widget for the Header Row
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    // Using hardcoded strings for buttons as CustomTexts constants were not available
    return const Text(
      'Profile',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Helper widget for Course/Location details
class _ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ProfileDetailRow({
    required this.icon,
    required this.text,
    this.color = Colors.black, // Default color
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Helper widget for Missing/Found stats
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color cardColor;
  final bool isError;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.cardColor,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine primary color based on item type or error state
    final Color primaryColor = isError 
      ? Colors.red 
      : (label.contains('Missing') ? Colors.orange : CustomColors.primary); // Example colors
    
    final Color textColor = isError 
      ? Colors.white 
      : Theme.of(context).textTheme.bodyLarge!.color!;
      
    // Adjust card color if there's an error to make it stand out
    final Color finalCardColor = isError ? primaryColor: cardColor;


    return Card(
      color: finalCardColor,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              icon, 
              size: 30, 
              color: isError ? Colors.white : primaryColor, // Icon color changes on error
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isError ? Colors.white : textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isError ? Colors.white : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}