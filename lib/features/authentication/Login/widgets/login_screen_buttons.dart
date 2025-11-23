import 'package:flutter/material.dart';
import 'package:ned_finder/features/Authentication/signup/sign_up_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class LoginScreenButtons extends StatelessWidget {
  const LoginScreenButtons({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);

    return Column(
      children: [

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed, 
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(CustomTexts.login),
          ),
        ),
        const SizedBox(height: 20),

        // Sign Up Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              CustomTexts.dontHaveAccount,
              style: TextStyle(
                  color: isDark
                      ? CustomColors.dmainTextColor
                      : CustomColors.lmainTextColor),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: const Text(
                CustomTexts.signUpHere,
                style: TextStyle(
                  color: CustomColors.textButtonColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
