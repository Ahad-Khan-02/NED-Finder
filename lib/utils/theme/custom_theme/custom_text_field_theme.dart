import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/sizes.dart';

class CustomTextFieldTheme {

  CustomTextFieldTheme._();


  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: CustomColors.secondary,
    floatingLabelStyle: const TextStyle(color: CustomColors.black),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(CustomSizes.borderRadiusLg),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(CustomSizes.borderRadiusLg),
      borderSide: const BorderSide(width: 2, color: CustomColors.black),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: Colors.white,
    floatingLabelStyle: const TextStyle(color: CustomColors.primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(CustomSizes.borderRadiusLg),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(CustomSizes.borderRadiusLg),
      borderSide: const BorderSide(width: 2, color: CustomColors.gradientBlue),
    ),
  );

}