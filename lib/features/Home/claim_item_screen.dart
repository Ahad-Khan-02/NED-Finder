import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimItemScreen extends StatefulWidget {
  final ItemModel item;

  const ClaimItemScreen({super.key, required this.item});

  @override
  State<ClaimItemScreen> createState() => _ClaimItemScreenState();
}

class _ClaimItemScreenState extends State<ClaimItemScreen> {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isClaiming = false;

  // Set the required length to 10 to match the backend validation
  static const int minClaimMessageLength = 10; 

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // --- API Call Logic ---
  Future<void> _submitClaim() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isClaiming = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getInt('user_id'); 

    if (currentUserId == null) {
      _showSnackBar('Error: User not logged in. Cannot submit claim.', isError: true);
      setState(() {
        _isClaiming = false;
      });
      return;
    }

    try {
      const endpoint = 'claim';
      
      // 1. Construct query parameters Map
      final queryParams = {
        'item_id': widget.item.id.toString(), 
        'user_id': currentUserId.toString(),
        'claim_message': _messageController.text,
      };

      // 2. CORRECTION: Use the dedicated helper method for query parameters.
      // This is the correct way to handle the backend expecting data in the URL query string.
      final response = await Http.postWithQueryParams(endpoint, queryParams); 

      if (response != null && response['status'] == 'success') {
        _showSnackBar(response['message'] ?? 'Item claim submitted successfully!', isError: false);
        Navigator.of(context).pop();
      } else {
        // Handle API error messages gracefully (400, 404, or 500 status)
        String apiErrorMessage = 'Claim failed. An unknown error occurred.';
        
        // 422 (FastAPI Validation Error structure)
        if (response != null && response.containsKey('detail') && response['detail'] is List) {
            final detailList = response['detail'] as List;
            if (detailList.isNotEmpty && detailList[0].containsKey('msg')) {
                // Display the specific message like "Field required" or a specific validation error
                apiErrorMessage = detailList[0]['msg'] as String;
            }
        } 
        // Custom backend error structure (e.g., from your Python code: status="failed", message=...)
        else if (response != null && response.containsKey('message')) {
            apiErrorMessage = response['message'].split(':')[1];
        }

        _showSnackBar(apiErrorMessage, isError: true);
      }
    } catch (e) {
      print('Claim Submission Error: $e');
      _showSnackBar('Connection failed. Check your network or API base URL.', isError: true);
    } finally {
      setState(() {
        _isClaiming = false;
      });
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? CustomColors.error : CustomColors.success,
        duration: const Duration(seconds: 4), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      appBar: AppBar(
        title: Text('Claim ${widget.item.name}'),
        backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Provide details to claim the item. Your message will be sent to the ${widget.item.itemType == 'lost' ? 'finder' : 'owner'} for verification.',
                style: TextStyle(
                    fontSize: 16, color: isDark ? Colors.white70 : Colors.black87),
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
                controller: _messageController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Claim Message / Details',
                  hintText: 'e.g., "The wallet had a blue key and two credit cards inside."',
                  prefixIcon: Icon(Icons.message),
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a detailed description for the claim.';
                  }
                  if (value.length < minClaimMessageLength) {
                    return 'Please enter at least $minClaimMessageLength characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isClaiming ? null : _submitClaim,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: CustomColors.primary,
                  ),
                  child: _isClaiming
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : const Text(
                          'Submit Claim',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}