import 'package:flutter/material.dart';
import 'package:ned_finder/Providers/Home/claim_item_provider.dart';
import 'package:provider/provider.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class ClaimItemScreen extends StatefulWidget {
  final ItemModel item;

  const ClaimItemScreen({super.key, required this.item});

  @override
  State<ClaimItemScreen> createState() => _ClaimItemScreenState();
}

class _ClaimItemScreenState extends State<ClaimItemScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize provider and clear any previous data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ClaimItemProvider>();
      provider.clearFields();
      provider.initialize();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark 
          ? CustomColors.darkBackground 
          : CustomColors.lightBackground,
      appBar: AppBar(
        title: Text('Claim ${widget.item.name}'),
        backgroundColor: isDark 
            ? CustomColors.darkBackground 
            : CustomColors.lightBackground,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Consumer<ClaimItemProvider>(
        builder: (context, claimProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: claimProvider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Provide details to claim the item. Also include your contact information. Your message will be sent to the ${widget.item.itemType == 'lost' ? 'finder' : 'owner'} for verification.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Item Name being claimed
                  Text(
                    'Item: ${widget.item.name}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Claim Message Text Field
                  TextFormField(
                    controller: claimProvider.messageController,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Claim Message / Details',
                      hintText: 'Describe why this item belongs to you and include your contact details. Example: "The wallet had a blue key and two credit cards. You can reach me at 0300-XXXXXXX."',
                      prefixIcon: Icon(Icons.message),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a detailed description for the claim.';
                      }
                      if (value.length < ClaimItemProvider.minClaimMessageLength) {
                        return 'Please enter at least ${ClaimItemProvider.minClaimMessageLength} characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: claimProvider.isClaiming
                          ? null
                          : () async {
                              final success = await claimProvider.submitClaim(widget.item);
                              
                              if (!mounted) return;
                              
                              if (success) {
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(claimProvider.successMessage ?? 'Claim submitted successfully!'),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                
                                // Wait 1.5 seconds to show the message
                                await Future.delayed(Duration(milliseconds: 1500));
                                
                                if (!mounted) return;
                                
                                // Clear fields and navigate back
                                claimProvider.clearFields();
                                Navigator.of(context).pop(true); // Pass true to indicate success
                              } else {
                                // Show error message
                                claimProvider.errorMessage != null? ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(claimProvider.errorMessage!),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                ):Container();
                              }
                            },
                      child: claimProvider.isClaiming
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Submitting...',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'Submit Claim',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}