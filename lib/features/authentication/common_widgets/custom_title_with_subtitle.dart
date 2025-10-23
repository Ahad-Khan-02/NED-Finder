import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';

class CustomTitlewithSubtitle extends StatelessWidget {
  const CustomTitlewithSubtitle({
    super.key, 
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: CustomColors.mainTextColor,
          ),
        ),
        const SizedBox(width: 8),
        
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: CustomColors.mainTextColor   
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

