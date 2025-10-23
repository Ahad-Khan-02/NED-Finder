import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class CustomTitlewithSubtitle extends StatefulWidget {
  const CustomTitlewithSubtitle({
    super.key, 
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  State<CustomTitlewithSubtitle> createState() => _CustomTitlewithSubtitleState();
}

class _CustomTitlewithSubtitleState extends State<CustomTitlewithSubtitle> {
  @override
  Widget build(BuildContext context) {

    bool isDark = HelperFunctions.isDarkMode(context);
    
    return Column(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            color: isDark? CustomColors.dmainTextColor : CustomColors.lmainTextColor,
          ),
        ),
        const SizedBox(width: 8),
        
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isDark? CustomColors.dmainTextColor : CustomColors.lmainTextColor,  
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

