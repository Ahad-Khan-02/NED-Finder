import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
// Assuming common widgets are in the paths below
import 'package:ned_finder/features/authentication/common_widgets/custom_title_with_subtitle.dart'; 
// Import the new form fields widget
import 'package:ned_finder/features/Home/widgets/found_item_form_fields.dart'; 

class ReportFoundItemScreen extends StatelessWidget {
  const ReportFoundItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title changed to reflect "Found Item" or "Add Item"
        title: const Text('Report Found Item', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: CustomColors.surfaceWhite,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: CustomColors.lightBackground, 
      
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: BoxDecoration(
              color: CustomColors.surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Header (Title and Subtitle)
                const CustomTitlewithSubtitle(
                  title: "Found Something?",
                  subtitle: "Thank you! Provide details about the item you found.",
                  alignment: CrossAxisAlignment.start, 
                ),
                const SizedBox(height: 30),

                // Main Form Fields
                const FoundItemFormFields(),
                const SizedBox(height: 30),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement form submission logic
                    print('Found Item Report submitted - Status: Pending');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryBlue,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Submit Report',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}