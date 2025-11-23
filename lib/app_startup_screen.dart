import 'package:flutter/material.dart';
import 'package:ned_finder/features/Admin/Admin_Dashboard/dashboard_screen.dart';
import 'package:ned_finder/features/Authentication/Login/login_screen.dart';
import 'package:ned_finder/features/Home/home_screen.dart';
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
    _checkLoginStatus(); 
  }

  void _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; 
    final String? role = prefs.getString('role');
    

    Future.microtask(() {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => role == 'admin' ? const AdminDashboardScreen() : const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}