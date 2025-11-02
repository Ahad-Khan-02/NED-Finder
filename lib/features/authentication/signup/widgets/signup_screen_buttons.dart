import 'package:flutter/material.dart';
import 'package:ned_finder/features/Authentication/Login/login_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class SignUpScreenButtons extends StatefulWidget {
  const SignUpScreenButtons({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  @override
  State<SignUpScreenButtons> createState() => _SignUpScreenButtonsState();
}

class _SignUpScreenButtonsState extends State<SignUpScreenButtons> {
  @override
  Widget build(BuildContext context) {

    bool isDark = HelperFunctions.isDarkMode(context); 

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        // 5. Login Button
        SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed:widget.onPressed,
                
        child: Text(CustomTexts.signup))
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              CustomTexts.alreadyHaveAccount,
              style: TextStyle(color:isDark? CustomColors.dmainTextColor : CustomColors.lmainTextColor),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
              },
              child: const Text(
                CustomTexts.login,
                style: TextStyle(
                  color: CustomColors.primary,
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