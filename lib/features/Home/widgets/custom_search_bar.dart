// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:ned_finder/utils/constants/sizes.dart';

// class CustomSearchBar extends StatefulWidget {
//   const CustomSearchBar({
//     super.key,
//     required this.text,
//     required this.color,
//   });

//   final String text;
//   final Color color;

//   @override
//   State<CustomSearchBar> createState() => _CustomSearchBarState();
// }

// class _CustomSearchBarState extends State<CustomSearchBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal:  CustomSizes.defaultSpace/6),
//       child: TextFormField(
//         decoration: InputDecoration(
//           prefixIcon: Icon(Iconsax.search_normal),
//           hint: Text(widget.text,style:TextStyle(color:  widget.color,)),
//           prefixIconColor: widget.color,
//           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: widget.color)),
//           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: widget.color)),
//         ),
//       ),
//     );
//   }
// }

















import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ned_finder/utils/constants/sizes.dart';

class CustomSearchBar extends StatefulWidget {
   const CustomSearchBar({
     super.key,
     required this.text,
     required this.color,
     this.onChanged, // New property: Callback for text changes
   });

   final String text;
   final Color color;
   final ValueChanged<String>? onChanged; // Function to call when text changes

   @override
   State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
   @override
   Widget build(BuildContext context) {
     return Padding(
        padding: const EdgeInsets.symmetric(horizontal:  CustomSizes.defaultSpace/6),
        child: TextFormField(
          onChanged: widget.onChanged, // Attach the callback to handle search input
          decoration: InputDecoration(
             prefixIcon: Icon(Iconsax.search_normal),
             hintText: widget.text, // Use hintText instead of 'hint'
             hintStyle: TextStyle(color:  widget.color,),
             prefixIconColor: widget.color,
             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: widget.color)),
             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: widget.color)),
          ),
        ),
     );
   }
}