import 'package:flutter/material.dart';
import 'package:ned_finder/features/authentication/common_widgets/custom_app_logo_with_title.dart';
import 'package:ned_finder/features/authentication/common_widgets/custom_title_with_subtitle.dart';
import 'package:ned_finder/features/authentication/Login/widgets/login_input_fields.dart';
import 'package:ned_finder/features/authentication/Login/widgets/login_screen_buttons.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: CustomColors.gradientColors,begin: Alignment.topCenter,end: Alignment.bottomCenter),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450), // To limit width on large screens
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: CustomColors.boxColor,
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
                  
                  LoginInputFields(),
        
                  // 4. Forgot Password Link
                  LoginScreenButtons(),
        
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





