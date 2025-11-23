import 'package:flutter/material.dart';
import 'package:ned_finder/features/Authentication/Auth%20Services/auth_services.dart';
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
  bool _isLoading = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  String user = 'student';
  String department = '';
  String year = '';

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

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
              constraints: const BoxConstraints(maxWidth: 450),
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
                  SignupInputFields(
                    password: passwordController, 
                    email: emailController, 
                    fullName: fullNameController, 
                    onDepartmentChanged: (selectedDepartment){
                      department = selectedDepartment!;
                    },
                    onYearChanged: (selectedYear){
                      year = selectedYear!;
                    },
                  ),
        
                 SignUpScreenButtons(
                  isLoading: _isLoading,
                    onPressed: () async {
                      if (_isLoading) return; 

                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          fullNameController.text.isEmpty ||
                          year.isEmpty ||
                          user.isEmpty ||
                          department.isEmpty) {
                        return HelperFunctions.showAlert(
                          "Missing Fields",
                          "Please fill all required fields."
                        );
                      }

                      setState(() {
                        _isLoading = true; 
                      });

                      try {
                        final response = await AuthService.signup(
                          role: user,
                          fullname: fullNameController.text.trim(),
                          email: emailController.text.trim(),
                          fieldOfStudy: department,
                          year: int.tryParse(year) ?? 1,
                          password: passwordController.text.trim(),
                        ); 


                        String msg = response["data"]?["message"] ??
                                    response["message"].toString().replaceAll("API Error (Status 400): ", "");                        
                        msg = msg.toString().replaceAll("Value error, ","");
                        msg = msg.toString().replaceAll("value is ","");
                        
                        HelperFunctions.showAlert(
                          response["status"] == "success" ? "Success" : "Signup Failed",
                          msg
                        );

                        if (response["status"] == "success") {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen())); // Go back to login
                        }

                      } catch (e) {
                        HelperFunctions.showAlert(
                          "Error",
                          "Failed to signup. Please try again.\nDetails: ${e.toString()}"
                        );
                      } finally {
                        setState(() {
                          _isLoading = false; 
                        });
                      }
                    },
                  ),       
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





