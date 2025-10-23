import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/sizes.dart';

class CustomOutlinedButtonTheme {

  CustomOutlinedButtonTheme._();

   static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: CustomColors.secondary,
      side: const BorderSide(color: CustomColors.secondary),
      padding: const EdgeInsets.symmetric(vertical: CustomSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CustomSizes.borderRadiusLg)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: CustomColors.white,
      side: const BorderSide(color: CustomColors.white),
      padding: const EdgeInsets.symmetric(vertical: CustomSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CustomSizes.borderRadiusLg)),
    ),
  );

}