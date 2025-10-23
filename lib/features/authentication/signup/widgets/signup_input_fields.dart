import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ned_finder/features/authentication/common_widgets/custom_input_fields.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class SignupInputFields extends StatefulWidget {
  const SignupInputFields({
    super.key,
  });

  @override
  State<SignupInputFields> createState() => _SignupInputFieldsState();
}

class _SignupInputFieldsState extends State<SignupInputFields> {

  final TextEditingController password = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdownField(icon: Icon(Icons.groups_3), text: CustomTexts.selectUser, items: ['user','admin'], onChanged: (user){}),
        CustomTextFormField(icon: Icon(Icons.person), text: CustomTexts.fullName),
        CustomTextFormField(icon: Icon(Icons.phone), text: CustomTexts.phoneNo),
        CustomDropdownField(icon: Icon(Icons.school), text: CustomTexts.selectDepartment, items: ['CIS','SE','BCIT','ME','IM','CE','FE'], onChanged: (department){}),
        CustomTextFormField(icon: Icon(Icons.email), text: CustomTexts.email),
         
        TextField(
          controller: password,
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



