import 'package:flutter/material.dart';
import 'package:ned_finder/features/Home/report_item/report_lost_item.dart';
import 'package:ned_finder/features/Home/widgets/Custom_Search_bar.dart';
import 'package:ned_finder/utils/constants/texts.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Page Title
          const Text(
            CustomTexts.home,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // 2. Search Bar
          CustomSearchBar(text: 'Search', color: Colors.black),
          const SizedBox(height: 20),

          // 3. Action Buttons (Add/Report)
          _buildActionButtons(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }


  Widget _buildActionButtons(context) {
    return Row(
      children: [
        // + Add Item Button
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.green),
          label: const Text(
            CustomTexts.addItem,
            style: TextStyle(color:  Colors.green, fontWeight: FontWeight.bold),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.green.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Report Item Button
        TextButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  ReportLostItemScreen()));
          },
          icon: const Icon(Icons.warning_amber, color: Colors.red),
          label: const Text(
            CustomTexts.reportItem,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}