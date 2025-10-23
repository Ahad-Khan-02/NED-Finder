import 'package:flutter/material.dart';
import 'package:ned_finder/features/authentication/Login/login_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class SignUpScreenButtons extends StatelessWidget {
  const SignUpScreenButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        // 5. Login Button
        SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: (){
          //login logic
        },
                
        child: Text(CustomTexts.signup))
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              CustomTexts.alreadyHaveAccount,
              style: TextStyle(color: Colors.black54),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
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