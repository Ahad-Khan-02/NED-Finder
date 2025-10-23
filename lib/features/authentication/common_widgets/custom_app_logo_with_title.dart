import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/images.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class CustomAppLogoWithTitle extends StatelessWidget {
  const CustomAppLogoWithTitle({
    super.key,
     this.height=100,
     this.width=100,
  });

  final double height;
  final double width;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(CustomImages.appLogo, height: height, width: width),
                         
        const Text(
          CustomTexts.appName,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: CustomColors.mainTextColor,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}