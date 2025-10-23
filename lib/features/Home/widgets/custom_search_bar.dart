import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ned_finder/utils/constants/sizes.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:  CustomSizes.defaultSpace/6),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Iconsax.search_normal),
          hint: Text(text,style:TextStyle(color:  color,)),
          prefixIconColor: color,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: color)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: color)),
        ),
      ),
    );
  }
}