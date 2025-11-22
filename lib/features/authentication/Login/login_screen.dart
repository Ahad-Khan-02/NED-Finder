import 'package:flutter/material.dart';
import 'package:ned_finder/features/Admin/Admin_Dashboard/dashboard_screen.dart';
import 'package:ned_finder/features/Authentication/Auth%20Services/auth_services.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_app_logo_with_title.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_title_with_subtitle.dart';
import 'package:ned_finder/features/Authentication/Login/widgets/login_input_fields.dart';
import 'package:ned_finder/features/Authentication/Login/widgets/login_screen_buttons.dart';
import 'package:ned_finder/features/Home/home_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isDark ? CustomColors.dgradientColors : CustomColors.lgradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: isDark ? CustomColors.dboxColor : CustomColors.lboxColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.shadowColor.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo & Title
                  CustomAppLogoWithTitle(),
                  CustomTitlewithSubtitle(
                    title: CustomTexts.loginTitle,
                    subtitle: CustomTexts.loginSubTitle,
                  ),
                  const SizedBox(height: 20),

                  // Input Fields
                  LoginInputFields(
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  LoginScreenButtons(
                    isLoading: _isLoading,
                    onPressed: () async {
                      if (_isLoading) return; // Prevent multiple clicks

                      // Validation
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        return HelperFunctions.showAlert(
                            'Alert', 'Please enter both email and password.');
                      }

                      setState(() => _isLoading = true);

                      try {
                        final response = await AuthService.login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );

                        final data = response['data'];

                        // Show backend message
                        response['status'] != 'success'? HelperFunctions.showAlert(
                          'Login Failed',
                          'Invalid Email or Password',
                        ):null;

                        if (response['status'] == 'success' && data != null) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isLoggedIn', true);
                          await prefs.setInt('user_id', data['user_id']);
                          await prefs.setString('email', data['email']);
                          await prefs.setString('role', data['role']);
                          await prefs.setString('fullname', data['fullname']);

                          // Navigate based on role
                          if (data['role'] == 'admin') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AdminDashboardScreen()),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          }
                        }
                      } catch (e) {
                        HelperFunctions.showAlert(
                          'Error',
                          'An error occurred during login.\nDetails: $e',
                        );
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
