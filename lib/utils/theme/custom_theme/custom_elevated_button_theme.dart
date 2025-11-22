import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/sizes.dart';

class CustomElevatedButtonTheme {

  CustomElevatedButtonTheme._();

    static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: CustomColors.white,
      backgroundColor: CustomColors.primary,
      side: const BorderSide(color: CustomColors.primary),
      padding: const EdgeInsets.symmetric(vertical: CustomSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CustomSizes.borderRadiusLg)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: CustomColors.white,
      backgroundColor: CustomColors.primary,
      side: const BorderSide(color: CustomColors.primary),
      padding: const EdgeInsets.symmetric(vertical: CustomSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CustomSizes.borderRadiusLg)),
    ),
  );
  
}