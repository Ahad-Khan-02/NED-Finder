import 'package:flutter/material.dart';
import 'package:ned_finder/features/authentication/common_widgets/custom_input_fields.dart';
import 'package:ned_finder/features/authentication/common_widgets/custom_title_with_subtitle.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  
  final TextEditingController _emailController = TextEditingController();

  // Function to simulate sending the reset link (you'd add actual logic here)
  void _sendResetLink() {
    String email = _emailController.text;
    if (email.isNotEmpty) {
      // In a real app, you'd call an API here.
      print('Sending reset link to: $email');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset link sent to $email! (Simulation)')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent,Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
              )
        ), 
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8.0, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), 
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    
                    // Header Text
                    
                    CustomTitlewithSubtitle(
                      title:  CustomTexts.forgotPassword, 
                      subtitle: CustomTexts.forgotPasswordSubTitle
                      ),

                    // Email Input Field

                    CustomTextFormField(icon: Icon(Icons.email), text: CustomTexts.email),
                   
                    const SizedBox(height: 30),

                   
                    SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: 
                      _sendResetLink
                    ,        
                    child: Text(CustomTexts.resetPassword))
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    },           
                    child: Text(CustomTexts.back)),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

