import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';

class CustomAppBarTheme {

  CustomAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: CustomColors.dark, size: 18.0),
    actionsIconTheme: IconThemeData(color: CustomColors.dark, size: 18.0),
  );
  
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: CustomColors.white, size: 18.0),
    actionsIconTheme: IconThemeData(color: CustomColors.white, size: 18.0),
  );

}