import 'package:flutter/material.dart';
import 'package:ned_finder/features/authentication/common_widgets/custom_app_logo_with_title.dart';
import 'package:ned_finder/features/authentication/common_widgets/custom_title_with_subtitle.dart';
import 'package:ned_finder/features/authentication/signup/widgets/signup_input_fields.dart';
import 'package:ned_finder/features/authentication/signup/widgets/signup_screen_buttons.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                  CustomTitlewithSubtitle(title: CustomTexts.signUpTitle, subtitle: CustomTexts.signUpSubTitle),
        
                  // 2. Email Input Field
                  
                  SignupInputFields(),
        
                  // 4. Forgot Password Link
                  SignUpScreenButtons(),
        
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





