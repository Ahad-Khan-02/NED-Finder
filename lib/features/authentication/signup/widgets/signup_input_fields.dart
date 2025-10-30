import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_input_fields.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class SignupInputFields extends StatefulWidget {
   SignupInputFields({
    super.key,
    required this.password,
    required this.email,
    required this.fullName,
    required this.phone, 
    required this.onUserChanged, 
    required this.onDepartmentChanged, 
    
  });

  final TextEditingController password;
  final TextEditingController email;
  final TextEditingController fullName;
  final TextEditingController phone;
  final Function(String?) onUserChanged;
  final Function(String?) onDepartmentChanged;

  @override
  State<SignupInputFields> createState() => _SignupInputFieldsState();
}

class _SignupInputFieldsState extends State<SignupInputFields> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdownField(icon: Icon(Icons.groups_3), text: CustomTexts.selectUser, items: ['Student','admin'], onChanged: widget.onUserChanged),
        CustomTextFormField(icon: Icon(Icons.person), text: CustomTexts.fullName,controller: widget.fullName,keyboardType: TextInputType.name,),
        CustomTextFormField(icon: Icon(Icons.phone), text: CustomTexts.phoneNo,controller: widget.phone,keyboardType: TextInputType.phone,),
        CustomDropdownField(icon: Icon(Icons.school), text: CustomTexts.selectDepartment, items: ['CIS','SE','BCIT','ME','IM','CE','FE','TE','AI','EE'], onChanged: widget.onDepartmentChanged),
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



