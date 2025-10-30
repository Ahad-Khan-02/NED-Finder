import 'package:flutter/material.dart';
import 'package:ned_finder/features/Admin/Admin_Dashboard/dashboard_screen.dart';
import 'package:ned_finder/features/Authentication/Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStartupScreen extends StatefulWidget {
  const AppStartupScreen({super.key});

  @override
  State<AppStartupScreen> createState() => _AppStartupScreenState();
}

class _AppStartupScreenState extends State<AppStartupScreen> {
  
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Call the check function on startup
  }

  void _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the saved 'isLoggedIn' flag, defaults to false if not set
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; 

    // Use Future.microtask to perform navigation after the current build cycle
    Future.microtask(() {
      if (isLoggedIn) {
        // User is logged in, go straight to the dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      } else {
        // User is not logged in, show the login screen
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading spinner while the check is in progress
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}