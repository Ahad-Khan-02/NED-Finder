import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ned_finder/utils/constants/colors.dart';



/* -- Light & Dark Text Themes -- */
class CustomTextTheme {
  CustomTextTheme._(); //To avoid creating instances

   /* -- Light Text Theme -- */
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(fontSize: 28.0, fontWeight: FontWeight.bold, color: CustomColors.dark),
    displayMedium: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w700, color: CustomColors.dark),
    displaySmall: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.normal, color: CustomColors.dark),
    headlineMedium: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600, color: CustomColors.dark),
    headlineSmall: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.normal, color: CustomColors.dark),
    titleLarge: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: CustomColors.dark),
    bodyLarge: GoogleFonts.poppins(fontSize: 14.0, color: CustomColors.dark),
    bodyMedium: GoogleFonts.poppins(fontSize: 14.0, color: CustomColors.dark.withValues(alpha: 0.8)),
  );

  /* -- Dark Text Theme -- */
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(fontSize: 28.0, fontWeight: FontWeight.bold, color: CustomColors.white),
    displayMedium: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w700, color: CustomColors.white),
    displaySmall: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.normal, color: CustomColors.white),
    headlineMedium: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600, color: CustomColors.white),
    headlineSmall: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.normal, color: CustomColors.white),
    titleLarge: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: CustomColors.white),
    bodyLarge: GoogleFonts.poppins(fontSize: 14.0, color: CustomColors.white),
    bodyMedium: GoogleFonts.poppins(fontSize: 14.0, color: CustomColors.white.withValues(alpha: 0.8)),
  );
}
