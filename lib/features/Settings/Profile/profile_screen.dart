import 'package:flutter/material.dart';
import 'package:ned_finder/Models/User/user_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';


// 1. Convert to StatefulWidget for better data management 
class ProfileScreen extends StatefulWidget {
  // Required: The ID of the user whose profile should be displayed
  // In a real app, this would be the current authenticated user's ID.
  final int userId; 
  
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Future to hold the result of the API call
  late Future<UserModel> _userProfileFuture;

  // Static stats for demonstration (These would typically also come from an API)
  final int _missingItems = 0;
  final int _foundItems = 1;

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
  void initState() {
    super.initState();
    // Start fetching the user data immediately using the passed userId
    _userProfileFuture = fetchUser(widget.userId);
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

                // Handle data state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show placeholders and a loading indicator
                } else if (snapshot.hasError) {
                  // Show error state
                  userName = 'Error';
                  userRole = 'Failed to load profile';
                  userEmail = snapshot.error.toString().replaceFirst('Exception: ', '');
                  
                  // Use a different color to indicate error
                  return _buildUserProfileSection(
                    userName: userName,
                    userRole: userRole,
                    userEmail: userEmail,
                    isError: true,
                  );
                } else if (snapshot.hasData) {
                  // Show successful data
                  final user = snapshot.data!;
                  userName = user.fullname;
                  // Use the user's role (e.g., Student, Admin) for the second detail row
                  userRole = user.capitalizedRole; 
                  userEmail = user.email;
                } else {
                  // Fallback state (No data/No error)
                  userName = 'Guest';
                  userRole = 'Login required';
                  userEmail = 'Not available';
                }

                // Build the UI based on the current data (or placeholders)
                return _buildUserProfileSection(
                  userName: userName,
                  userRole: userRole,
                  userEmail: userEmail,
                );
              },
            ),

            const SizedBox(height: 40),
            
            // --- Stats Cards (Missing/Found Items) ---
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.help_outline,
                    label: 'Missing Item',
                    count: _missingItems,
                    cardColor: cardColor,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_outline,
                    label: 'Found Item',
                    count: _foundItems,
                    cardColor: cardColor,
                  ),
                ),
              ],
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
          child: _userProfileFuture == null || 
                 (isError && _userProfileFuture.runtimeType != Future<UserModel>) // Simple error check to avoid spinner on error
              ? const Icon(Icons.person, size: 70, color: Colors.white)
              : FutureBuilder(
                  future: _userProfileFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
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

class UserService {
}

// -------------------------------------------------------------
// Extracted Private Widgets (Minor updates to accept color)
// -------------------------------------------------------------

// Helper widget for the Header Row
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
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

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 30, ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}