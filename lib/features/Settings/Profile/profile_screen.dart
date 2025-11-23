import 'package:flutter/material.dart';
import 'package:ned_finder/Models/User/user_item_stat_model.dart';
import 'package:ned_finder/Models/User/user_model.dart'; 
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';


class ProfileScreen extends StatefulWidget {
  final int userId; 
  
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> _userProfileFuture;

  late Future<UserItemStatsModel> _itemStatsFuture;

  static Future<UserModel> fetchUser(int userId) async {
    final endpoint = 'users/$userId'; 
    final result = await Http.get(endpoint);

    if (result['status'] == 'success' && result.containsKey('data')) {
      return UserModel.fromJson(result['data'] as Map<String, dynamic>);
    } else {
      throw Exception(result['message'] ?? 'Failed to load user profile.');
    }
  }

  static Future<UserItemStatsModel> fetchItemStats(int userId) async {
    final endpoint = 'my-items/$userId'; 
    final result = await Http.get(endpoint);

    if (result['status'] == 'success' && result.containsKey('data')) {
      final data = result['data'] as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;

      int foundCount = 0;
      int missingCount = 0;

      for (var item in items) {
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
    _userProfileFuture = fetchUser(widget.userId);
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
            const _ProfileHeader(),
            const SizedBox(height: 32),
            
            FutureBuilder<UserModel>(
              future: _userProfileFuture,
              builder: (context, snapshot) {
                String userName = 'Loading Name...';
                String userRole = 'Loading Role...';
                String userEmail = 'Loading Email...';
                bool isError = false;

                if (snapshot.connectionState == ConnectionState.waiting) {
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
                  userProfileFuture: _userProfileFuture,
                );
              },
            ),

            const SizedBox(height: 40),
            
            FutureBuilder<UserItemStatsModel>(
              future: _itemStatsFuture,
              builder: (context, snapshot) {

                int missingCount = 0;
                int foundCount = 0;
                bool isStatsError = false;
                
                if (snapshot.connectionState == ConnectionState.waiting) {
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

  Widget _buildUserProfileSection({
    required String userName,
    required String userRole,
    required String userEmail,
    required Future<UserModel> userProfileFuture,
    bool isError = false,
  }) {

    final Color detailColor = isError ? Colors.red : Theme.of(context).textTheme.bodyMedium!.color!;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              return const Icon(Icons.person, size: 70, color: Colors.white);
            },
          ),
        ),
        const SizedBox(width: 24),

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
              
              // Department
              _ProfileDetailRow(
                icon: Icons.school_outlined,
                text: userRole,
                color: detailColor,
              ),
              const SizedBox(height: 4),
              
              // Email
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

class _ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ProfileDetailRow({
    required this.icon,
    required this.text,
    this.color = Colors.black, 
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
    final Color primaryColor = isError 
      ? Colors.red 
      : (label.contains('Missing') ? Colors.orange : CustomColors.primary); 
    
    final Color textColor = isError 
      ? Colors.white 
      : Theme.of(context).textTheme.bodyLarge!.color!;
      
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
              color: isError ? Colors.white : primaryColor, 
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