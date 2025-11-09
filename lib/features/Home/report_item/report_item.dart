import 'package:flutter/material.dart';
import 'package:ned_finder/features/Home/report_item/report_item_form_fields.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/features/Authentication/common_widgets/custom_title_with_subtitle.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart'; 

class ReportItemScreen extends StatelessWidget {
  const ReportItemScreen({super.key, required this.appBarTitle,required this.isLost});

  final String appBarTitle;
  
  final bool isLost;

  @override
  Widget build(BuildContext context) {

    bool isDark = HelperFunctions.isDarkMode(context);

    // Scaffold provides the app bar and main structure 
    return Scaffold(
      appBar: AppBar(
        title:  Text(isLost? CustomTexts.reportLostItem : CustomTexts.reportFoundItem, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark? CustomColors.darkBackground : CustomColors.lightBackground,
        foregroundColor: isDark? Colors.white : Colors.black,
        elevation: 0,
      ),
      // Use the light blue background across the whole body
      backgroundColor: isDark? CustomColors.darkBackground :CustomColors.lightBackground, 
      
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500), // Max width for a clean form layout
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: BoxDecoration(
              color: isDark? CustomColors.dark : CustomColors.lightContainer, // White card container
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Header (Title and Subtitle) "Lost Something?"
                CustomTitlewithSubtitle(
                  title: isLost? CustomTexts.reportLostItemTitle : CustomTexts.reportFoundItemTitle,
                  subtitle: isLost? CustomTexts.reportLostItemDescription : CustomTexts.reportFoundItemDescription,      
                ),
                const SizedBox(height: 30),

                // Main Form Fields
                ReportItemFormFields(isLost: isLost),
                

                // // Submit Button
                // ElevatedButton(
                //   onPressed: () {
                //     print('Submit button pressed - Status: Pending');
                //   },     
                //   child: const Text(
                //     CustomTexts.submit,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}