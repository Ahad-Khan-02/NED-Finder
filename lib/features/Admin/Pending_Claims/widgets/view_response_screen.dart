import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Claims/pending_claim_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; // Import Http client

class ViewResponseScreen extends StatefulWidget {

  final PendingClaimModel claim; 

  const ViewResponseScreen({super.key, required this.claim});

  @override
  State<ViewResponseScreen> createState() => _ViewResponseScreenState();
}

class _ViewResponseScreenState extends State<ViewResponseScreen> {
  bool _isProcessing = false;
  String? _statusMessage;

  Future<void> _updateClaimStatus(String action) async {
    setState(() {
      _isProcessing = true;
      _statusMessage = null;
    });

    final endpoint = 'claims/${widget.claim.id}/$action'; 
    final isApproval = action == 'approve';

    try {
      final responseData = await Http.put(endpoint); 

      if (responseData['status'] == 'success') {
        setState(() {
          _statusMessage = 'Claim successfully ${isApproval ? 'approved' : 'rejected'}.';
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });

      } else {
        throw Exception(responseData['message'] ?? 'Failed to process claim.');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error processing claim: ${e.toString()}';
      });
      HelperFunctions.showSnackBar(_statusMessage!);
    } finally {
      if(mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showConfirmationDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: text=='approve' ? const Text('Confirm Item Approval') : const Text('Confirm Item Rejection'),
          content: text=='approve' ? const Text('Are you sure you want to approve this item? This action cannot be undone.') : const Text('Are you sure you want to reject this item? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('Cancel', style: TextStyle(color:  CustomColors.darkerGrey)),
            ),
            TextButton(onPressed: () {
                Navigator.of(context).pop();
                _updateClaimStatus(text);
              }, child: text=='approve' ? const Text('Approve', style: TextStyle(color: CustomColors.primary)) : const Text('Reject', style: TextStyle(color: CustomColors.error))
            )
          ]
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final bool hasImage = widget.claim.itemImageBytes.isNotEmpty;

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      appBar: AppBar(
        title: const Text(CustomTexts.reviewPendingClaim),
        backgroundColor: isDark ? CustomColors.darkBackground :CustomColors.lightBackground,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (_statusMessage != null) 
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(
                    color: _statusMessage!.contains('Error') ? CustomColors.error : CustomColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            _buildImageDisplayCard(hasImage, widget.claim.itemImageBytes),

            const SizedBox(height: 32),

            const Text(
              CustomTexts.claimerDetailsAndJustification,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomColors.primary),
            ),
            const SizedBox(height: 16),
            
            _buildClaimDetailSection(isDark, claim: widget.claim),

            const SizedBox(height: 32),

            
            SizedBox(
              width:double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : () => _showConfirmationDialog('approve'),
                icon: _isProcessing ? const SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                ) : const Icon(Icons.check_circle_outline),
                label: Text(_isProcessing ? 'Processing...' : 'APPROVE Claim'), 
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.transparent),
                  backgroundColor: CustomColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Reject Button
            SizedBox(
              width:double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isProcessing ? null : () => _showConfirmationDialog('reject'),
                icon: const Icon(Icons.cancel_outlined, color: CustomColors.error),
                label: const Text('REJECT Claim', style: TextStyle(color: CustomColors.error)), 
                style: OutlinedButton.styleFrom(
                  backgroundColor: CustomColors.error.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: CustomColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageDisplayCard(bool hasImage,imageBytes) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: CustomColors.lboxColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: hasImage
            ? Image.memory(
                imageBytes,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported_outlined, size: 50, color: CustomColors.error),
                      Text('Image Load Error', style: TextStyle(color: CustomColors.error)),
                    ],
                  ),
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 50, color: CustomColors.info),
                    Text('No Item Image Provided', style: TextStyle(color: CustomColors.info)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildClaimDetailSection(
    bool isDark, {
    required PendingClaimModel claim,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? CustomColors.dark : CustomColors.lboxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item: ${claim.itemName}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          
          _buildInfoRow(Icons.person, 'Claimer: ${claim.username}', isDark),
          
          _buildInfoRow(Icons.numbers, 'Claim ID: ${claim.id} (Item ID: ${claim.itemId})', isDark),
          
          _buildInfoRow(Icons.calendar_today, 'Date Claimed: ${claim.dateString} at ${claim.timeString}', isDark),
          
          const Divider(height: 24),

          const Text(
            CustomTexts.claimerJustification,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.primary),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              claim.claimMessage,
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: isDark ? CustomColors.white : CustomColors.dark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: CustomColors.primary.withOpacity(0.7)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: isDark ? CustomColors.white : CustomColors.dark),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}