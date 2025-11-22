import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_input_fields.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class SignupInputFields extends StatefulWidget {
   const SignupInputFields({
    super.key,
    required this.password,
    required this.email,
    required this.fullName,
    required this.onDepartmentChanged,
    required this.onYearChanged, 
  });

  final TextEditingController password;
  final TextEditingController email;
  final TextEditingController fullName;
  final Function(String?) onDepartmentChanged;
  final Function(String?) onYearChanged;

  @override
  State<SignupInputFields> createState() => _SignupInputFieldsState();
}

class _SignupInputFieldsState extends State<SignupInputFields> {
  bool _obscureText = true;
  List<String> nedDepartments = [
  "Civil Engineering",
  "Urban & Infrastructure Engineering",
  "Petroleum Engineering",
  "Earthquake Engineering",
  "Environmental Engineering",
  "Mechanical Engineering",
  "Industrial & Manufacturing Engineering",
  "Textile Engineering",
  "Automotive & Marine Engineering",
  "Electrical Engineering",
  "Computer & Information Systems Engineering",
  "Electronic Engineering",
  "Telecommunications Engineering",
  "Biomedical Engineering",
  "Chemical Engineering",
  "Polymer & Petrochemical Engineering",
  "Materials Engineering",
  "Metallurgical Engineering",
  "Food Engineering",
  "Architecture & Planning",
  "Economics & Management Sciences",
  "Mathematics",
  "Physics",
  "Chemistry",
  "English Linguistics & Allied Studies",
  "Essential Studies"
];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(icon: Icon(Icons.person), text: CustomTexts.fullName,controller: widget.fullName,keyboardType: TextInputType.name,),
        CustomDropdownField(icon: Icon(Icons.school), text: CustomTexts.selectDepartment, items: nedDepartments, onChanged: widget.onDepartmentChanged),
        CustomDropdownField(icon: Icon(Icons.calendar_month), text: CustomTexts.year, items: ['1','2','3','4'], onChanged: widget.onYearChanged),
        CustomTextFormField(icon: Icon(Icons.email), text: CustomTexts.email,controller: widget.email,keyboardType: TextInputType.emailAddress,),
         
        TextField(
          controller: widget.password,
          obscureText: _obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            labelText: CustomTexts.password,
            suffixIcon: IconButton(
             onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
                },
                icon: Icon(
                  _obscureText ? Iconsax.eye_slash : Iconsax.eye, 
                ),
          ),
        ) ,
      ),  
        const SizedBox(height: 8),
      ],
    );
  }
}



