import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/sizes.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key, required this.icon, required this.text, required this.controller,this.keyboardType=TextInputType.text,
  });

  final Icon icon;
  final String text;
  final TextEditingController controller;
  final TextInputType keyboardType;
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: icon,
            labelText: text,
          ),
          ),
        SizedBox(
          height: CustomSizes.spaceBtwInputFields/3,
        ),
      ],
    ); 
  }
}


class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.icon,
    required this.text,
    required this.items,
    required this.onChanged,
    this.value,
  });

  final Icon icon;
  final String text;
  final List<String> items;
  final String? value;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: icon,
            labelText: text,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        const SizedBox(
          height:CustomSizes.spaceBtwInputFields / 3 ,
        ),
      ],
    );
  }
}