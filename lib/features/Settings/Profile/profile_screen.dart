import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

// 1. Convert to StatefulWidget for better data management (though it's optional)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dummy data (now private state properties)
  final String _userName = CustomTexts.userName; // "John Matthew Perez"
  final String _userCourse = 'BSCS 1B'; // Changed from 'CIS' to match image better
  final String userEmail = 'khan4602360@neduet.edu.pk';
  final int _missingItems = 0;
  final int _foundItems = 1;

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final Color cardColor = isDark ? CustomColors.dark : CustomColors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark? CustomColors.darkBackground : CustomColors.lightBackground,
        elevation: 0,
        foregroundColor: isDark? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Row (Profile Title and Actions) ---
            _ProfileHeader(),
            const SizedBox(height: 32),
      
            // --- Main Profile Info Section (FIXED ALIGNMENT) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Keep avatar and text aligned to top
              children: [
                // Profile Avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColors.primary.withOpacity(0.8),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 24),
      
                // User Details (Vertically Aligned)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name is slightly higher to align with the top of the avatar circle
                      Text(
                        _userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Removed extra vertical space here to tighten alignment
                      
                      // Course/Role
                      _ProfileDetailRow(
                        icon: Icons.school_outlined,
                        text: _userCourse,
                      ),
                      const SizedBox(height: 4),
                      // Location
                      _ProfileDetailRow(
                        icon: Icons.location_on_outlined,
                        text: userEmail,
                      ),
                    ],
                  ),
                ),
              ],
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
}

// -------------------------------------------------------------
// 2. Extracted Private Widgets for better organization and clarity
// -------------------------------------------------------------

// Helper widget for the Header Row
class _ProfileHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            // Edit Button (Swapped to ElevatedButton.icon for the primary style)
            ElevatedButton(onPressed: (){},
             child: SizedBox(
              width: 110,
               child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.edit, size: 18),
                   Text(CustomTexts.editProfile),
                ]),
             )),

            const SizedBox(width: 8),

            ElevatedButton(onPressed: (){},
             child: SizedBox(
              width: 110,
               child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.logout, size: 18),
                   Text(CustomTexts.logout),
                ]),
             )),
          ],
        ),
      ],
    );
  }
}

// Helper widget for Course/Location details
class _ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProfileDetailRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: 16,),
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
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
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