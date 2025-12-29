import 'package:flutter/material.dart';
import 'package:ned_finder/Providers/Authentication/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:ned_finder/features/Admin/Admin_Dashboard/dashboard_screen.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_app_logo_with_title.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_title_with_subtitle.dart';
import 'package:ned_finder/features/Authentication/Login/widgets/login_input_fields.dart';
import 'package:ned_finder/features/Authentication/Login/widgets/login_screen_buttons.dart';
import 'package:ned_finder/features/Home/home_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;
    
    // Responsive padding
    final horizontalPadding = isSmallScreen ? 16.0 : (isTablet ? 32.0 : 48.0);
    final verticalPadding = isSmallScreen ? 16.0 : 24.0;
    
    // Responsive container constraints
    final maxWidth = isSmallScreen ? double.infinity : (isTablet ? 500.0 : 450.0);
    
    // Responsive box padding
    final boxHorizontalPadding = isSmallScreen ? 20.0 : 24.0;
    final boxVerticalPadding = isSmallScreen ? 32.0 : 40.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark ? CustomColors.dgradientColors : CustomColors.lgradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: EdgeInsets.symmetric(
                  horizontal: boxHorizontalPadding,
                  vertical: boxVerticalPadding,
                ),
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
                child: Consumer<LoginProvider>(
                  builder: (context, loginProvider, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Logo & Title
                        CustomAppLogoWithTitle(),
                        CustomTitlewithSubtitle(
                          title: CustomTexts.loginTitle,
                          subtitle: CustomTexts.loginSubTitle,
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 20),

                        // Input Fields
                        LoginInputFields(
                          emailController: loginProvider.emailController,
                          passwordController: loginProvider.passwordController,
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 20),

                        // Login Button
                        LoginScreenButtons(
                          isLoading: loginProvider.isLoading,
                          onPressed: () async {
                            final success = await loginProvider.login(context);
                            
                            if (success) {
                              // Get role from SharedPreferences
                              final prefs = await SharedPreferences.getInstance();
                              final role = prefs.getString('role');
                              
                              if (role == 'admin') {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminDashboardScreen(),
                                  ),
                                  (_) => false,
                                );
                              } else {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                  (_) => false,
                                );
                              }
                            }
                          },
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 20),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}