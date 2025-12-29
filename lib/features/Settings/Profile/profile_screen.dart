import 'package:flutter/material.dart';
import 'package:ned_finder/Providers/Settings/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize provider when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().initialize(widget.userId);
    });
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
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ProfileHeader(),
                const SizedBox(height: 32),
                
                // User Profile Section
                _buildUserProfileSection(
                  provider: profileProvider,
                  isDark: isDark,
                ),
                      
                const SizedBox(height: 40),
                
                // Statistics Section
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.help_outline,
                        label: profileProvider.statsError != null 
                            ? 'Error' 
                            : 'Missing Item',
                        count: profileProvider.missingItemsCount,
                        cardColor: cardColor,
                        isLoading: profileProvider.isLoadingStats,
                        isError: profileProvider.statsError != null,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle_outline,
                        label: profileProvider.statsError != null 
                            ? 'Error' 
                            : 'Found Item',
                        count: profileProvider.foundItemsCount,
                        cardColor: cardColor,
                        isLoading: profileProvider.isLoadingStats,
                        isError: profileProvider.statsError != null,
                      ),
                    ),
                  ],
                ),
                
                // Error message for stats
                if (profileProvider.statsError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            profileProvider.statsError!,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () => profileProvider.fetchItemStats(widget.userId),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfileSection({
    required ProfileProvider provider,
    required bool isDark,
  }) {
    final bool isError = provider.userError != null;
    final Color detailColor = isError 
        ? Colors.red 
        : (isDark ? Colors.white : Colors.black);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Picture
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isError 
                ? Colors.red.shade400 
                : CustomColors.primary.withOpacity(0.8),
          ),
          child: provider.isLoadingUser
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Icon(Icons.person, size: 70, color: Colors.white),
        ),
        const SizedBox(width: 24),

        // User Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              provider.isLoadingUser
                  ? _LoadingText(width: 150)
                  : Text(
                      isError ? 'Error' : provider.userName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: detailColor,
                      ),
                    ),
              
              const SizedBox(height: 8),
              
              // Department
              provider.isLoadingUser
                  ? _LoadingText(width: 120)
                  : _ProfileDetailRow(
                      icon: Icons.school_outlined,
                      text: isError 
                          ? 'Profile Load Failed' 
                          : provider.userRole,
                      color: detailColor,
                    ),
              const SizedBox(height: 4),
              
              // Email
              provider.isLoadingUser
                  ? _LoadingText(width: 180)
                  : _ProfileDetailRow(
                      icon: Icons.alternate_email,
                      text: isError 
                          ? provider.userError!.replaceFirst('Exception: ', '')
                          : provider.userEmail,
                      color: detailColor,
                    ),
              
              // Retry button on error
              if (isError)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ElevatedButton.icon(
                    onPressed: () => provider.fetchUser(widget.userId),
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Loading placeholder widget
class _LoadingText extends StatelessWidget {
  final double width;
  
  const _LoadingText({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
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
  final bool isLoading;
  final bool isError;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.cardColor,
    this.isLoading = false,
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
        
    final Color finalCardColor = isError ? primaryColor : cardColor;

    return Card(
      color: finalCardColor,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? Column(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ],
              )
            : Column(
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
