import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/images.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class CustomAppLogoWithTitle extends StatefulWidget {
  const CustomAppLogoWithTitle({
    super.key,
     this.height=100,
     this.width=100,
  });

  final double height;
  final double width;

  @override
  State<CustomAppLogoWithTitle> createState() => _CustomAppLogoWithTitleState();
}

class _CustomAppLogoWithTitleState extends State<CustomAppLogoWithTitle> {
  @override
  Widget build(BuildContext context) {

    bool isDark = HelperFunctions.isDarkMode(context);
    
    return Column(
      children: [
        Image.asset(CustomImages.appLogo, height: widget.height, width: widget.width),
                         
        Text(
          CustomTexts.appName,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isDark? CustomColors.dmainTextColor : CustomColors.lmainTextColor,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}