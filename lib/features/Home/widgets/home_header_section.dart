import 'package:flutter/material.dart';
import 'package:ned_finder/features/Home/report_item/report_item.dart';
import 'package:ned_finder/features/Home/widgets/Custom_Search_bar.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class HomeHeaderSection extends StatefulWidget {
  const HomeHeaderSection({super.key, this.isMyitemsScreen= false, required this.isSettingsScreen});
  
  final bool isMyitemsScreen;
  final bool isSettingsScreen;

  @override
  State<HomeHeaderSection> createState() => _HomeHeaderSectionState();
}

class _HomeHeaderSectionState extends State<HomeHeaderSection> {
  String _selectedFilter = CustomTexts.allItemsFilter; 
 // Initial filter value
  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Page Title
           Text(
            widget.isSettingsScreen? CustomTexts.settings :widget.isMyitemsScreen? CustomTexts.myItems :CustomTexts.home,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          widget.isMyitemsScreen? Container(): const SizedBox(height: 20),

          // 2. Search Bar
          widget.isSettingsScreen? Container():widget.isMyitemsScreen?  _buildActionDropDown(context) :CustomSearchBar(text: 'Search', color: isDark? Colors.white : Colors.black),
          widget.isMyitemsScreen||widget.isSettingsScreen? Container():const SizedBox(height: 20),

          // 3. Action Buttons (Add/Report)
          widget.isMyitemsScreen||widget.isSettingsScreen? const SizedBox() : _buildActionButtons(context),
          widget.isSettingsScreen? Container():const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActionDropDown(context) {
    // Filter Dropdown Section
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedFilter,
            icon: const Icon(Icons.arrow_drop_down),
            style: const TextStyle(color:  Colors.black, fontSize: 16),
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });
            },
            items: <String>[
              CustomTexts.allItemsFilter,
              CustomTexts.lostItemsFilter,
              CustomTexts.foundItemsFilter,
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(context) {
    return Row(
      children: [
        // + Add Item Button
        TextButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  ReportItemScreen(isLost: false, appBarTitle: CustomTexts.reportFoundItem, )));
          },
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
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  ReportItemScreen(isLost: true, appBarTitle: CustomTexts.reportLostItem)));
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