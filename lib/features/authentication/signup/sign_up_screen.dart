import 'package:flutter/material.dart';
import 'package:ned_finder/Providers/Authentication/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:ned_finder/features/Authentication/Login/login_screen.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_app_logo_with_title.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_title_with_subtitle.dart';
import 'package:ned_finder/features/Authentication/signup/widgets/signup_input_fields.dart';
import 'package:ned_finder/features/Authentication/signup/widgets/signup_screen_buttons.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    // Clear fields when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignupProvider>().clearFields();
    });
  }

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
    final maxWidth = isSmallScreen ? double.infinity : (isTablet ? 550.0 : 500.0);
    
    // Responsive box padding
    final boxHorizontalPadding = isSmallScreen ? 20.0 : 24.0;
    final boxVerticalPadding = isSmallScreen ? 24.0 : 32.0;

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
                child: Consumer<SignupProvider>(
                  builder: (context, signupProvider, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Logo and Title
                        CustomAppLogoWithTitle(),
                        CustomTitlewithSubtitle(
                          title: CustomTexts.signUpTitle,
                          subtitle: CustomTexts.signUpSubTitle,
                        ),

                        // Input Fields
                        SignupInputFields(
                          password: signupProvider.passwordController,
                          email: signupProvider.emailController,
                          fullName: signupProvider.fullNameController,
                          onDepartmentChanged: (selectedDepartment) {
                            signupProvider.setDepartment(selectedDepartment!);
                          },
                          onYearChanged: (selectedYear) {
                            signupProvider.setYear(selectedYear!);
                          },
                        ),

                        SignUpScreenButtons(
                          isLoading: signupProvider.isLoading,
                          onPressed: () async {
                            final success = await signupProvider.signup();
                            
                            if (success) {
                              // Use GetX navigation
                              Get.off(() => LoginScreen());
                              
                              // Or use regular Navigator
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => LoginScreen(),
                              //   ),
                              // );
                            }
                          },
                        ),
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