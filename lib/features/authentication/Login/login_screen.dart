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

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    bool isDark = HelperFunctions.isDarkMode(context);



    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: isDark? CustomColors.dgradientColors : CustomColors.lgradientColors,begin: Alignment.topCenter,end: Alignment.bottomCenter),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450), // To limit width on large screens
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: isDark?  CustomColors.dboxColor: CustomColors.lboxColor,
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
        
                  // 1. Logo and Title
                  CustomAppLogoWithTitle(),
                  CustomTitlewithSubtitle(title: CustomTexts.loginTitle, subtitle: CustomTexts.loginSubTitle),
        
                  // 2. Email Input Field
                  
                  LoginInputFields(emailController: email, passwordController: password),
        
                  // 4. Forgot Password Link
                  LoginScreenButtons(
                    onPressed: () async {
                    //   if (email.text.isEmpty || password.text.isEmpty) {
                    //     return HelperFunctions.showAlert('Alert', 'Please enter both email and password.');
                    //   }

                    //   try {
                    //     final response = await AuthService.login(
                    //       email.text.trim(),
                    //       password.text.trim(),
                    //     );

                    //     if (response["status"] == "success") {
                    //       final prefs = await SharedPreferences.getInstance();
                    //       await prefs.setBool('isLoggedIn', true);

                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(builder: (_) => HomeScreen()),
                    //       );
                    //     } else {
                    //       HelperFunctions.showAlert("Login Failed", response["message"]);
                    //     }
                    //   } catch (e) {
                    //     HelperFunctions.showAlert("Error", "Something went wrong: $e");
                    //   }
                    // },


                      // Check if either the email or the password field is empty (Corrected condition)
                      if (email.text.isEmpty || password.text.isEmpty) { // Corrected: Use '||' (OR)
                        // 2. Display an alert for missing credentials
                        return HelperFunctions.showAlert('Alert', 'Please enter both email and password.');
                      }

                      // --- Placeholder for Actual Login Logic ---
                      
                      // 3. Authenticate the user (e.g., using a service/API call)
                      final String userEmail = email.text.trim();
                      final String userPassword = password.text.trim();

                      // Imagine a function that attempts to log in and returns a boolean or user object
                      // You would typically wrap this in a try-catch for error handling
                      try {
                          // Replace 'AuthService.loginUser' with your actual login function/service
                          // bool loginSuccess = await AuthService.loginUser(userEmail, userPassword);
                          

                          if ((userEmail == 'user' && userPassword == '123') || 
                              (userEmail == 'admin' && userPassword == '123')) {
                            // 4. Successful Login: Navigate to the dashboard
                            // The 'context' should be valid here
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', true); // Save the login state
                            Navigator.pushReplacement( // Use pushReplacement to prevent going 'back' to the login screen
                              context, 
                               MaterialPageRoute(builder: (context) => userEmail == 'user'? HomeScreen() : AdminDashboardScreen()),
                            );
                          } else {
                            // 5. Unsuccessful Login (e.g., wrong credentials)
                            HelperFunctions.showAlert('Login Failed', 'Invalid email or password. Please try again.');
                          }

                      } catch (e) {
                          // 6. Handle any errors during the login process (e.g., network issues)
                          HelperFunctions.showAlert('Error', 'An error occurred during login. Please try again later.');
                      }   
                    }, 
                  ),
        
                  // 6. Sign Up Link
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





