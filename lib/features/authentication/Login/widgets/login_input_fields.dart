import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_input_fields.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class LoginInputFields extends StatefulWidget {
  const LoginInputFields({
    super.key,
  });

  @override
  State<LoginInputFields> createState() => _LoginInputFieldsState();
}

class _LoginInputFieldsState extends State<LoginInputFields> {

  final TextEditingController password = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        CustomTextFormField(icon: Icon(Icons.email), text:  CustomTexts.email),
                
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