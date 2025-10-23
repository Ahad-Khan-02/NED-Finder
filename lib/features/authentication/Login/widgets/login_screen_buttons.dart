import 'package:flutter/material.dart';
import 'package:ned_finder/features/Home/home_screen.dart';
import 'package:ned_finder/features/authentication/forgot_password/forgot_password_screen.dart';
import 'package:ned_finder/features/authentication/signup/sign_up_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class LoginScreenButtons extends StatelessWidget {
  const LoginScreenButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  ForgotPasswordScreen()));
            },
            child: const Text(
              CustomTexts.forgotPassword,
              style: TextStyle(
                color: CustomColors.textButtonColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        
                
        // 5. Login Button
        SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomeScreen()));

        },
                
        child: Text(CustomTexts.login))
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              CustomTexts.dontHaveAccount,
              style: TextStyle(color: Colors.black54),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  SignUpScreen()));
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