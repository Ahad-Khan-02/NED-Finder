import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ned_finder/utils/constants/sizes.dart';

class CustomSearchBar extends StatefulWidget {
   const CustomSearchBar({
     super.key,
     required this.text,
     required this.color,
     this.onChanged, 
   });

   final String text;
   final Color color;
   final ValueChanged<String>? onChanged; 

   @override
   State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
   @override
   Widget build(BuildContext context) {
     return Padding(
        padding: const EdgeInsets.symmetric(horizontal:  CustomSizes.defaultSpace/6),
        child: TextFormField(
          onChanged: widget.onChanged,
          decoration: InputDecoration(
             prefixIcon: Icon(Iconsax.search_normal),
             hintText: widget.text,
             hintStyle: TextStyle(color:  widget.color,),
             prefixIconColor: widget.color,
             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: widget.color)),
             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: widget.color)),
          ),
        ),
     );
   }
}