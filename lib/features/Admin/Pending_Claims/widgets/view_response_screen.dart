import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Claims/pending_claim_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; // Import Http client

class ViewResponseScreen extends StatefulWidget {
  // Accepts the PendingClaimModel
  final PendingClaimModel claim; 

  const ViewResponseScreen({super.key, required this.claim});

  @override
  State<ViewResponseScreen> createState() => _ViewResponseScreenState();
}

class _ViewResponseScreenState extends State<ViewResponseScreen> {
  // --- State for actions ---
  bool _isProcessing = false;
  String? _statusMessage;

  // --- API ACTION: Approve/Reject Claim ---
  Future<void> _updateClaimStatus(String action) async {
    setState(() {
      _isProcessing = true;
      _statusMessage = null;
    });

    final endpoint = 'claims/${widget.claim.id}/$action'; // 'claims/1/approve' or 'claims/1/reject'
    final isApproval = action == 'approve';

    try {
      // Use the standard PUT method (assuming the API is idempotent and returns 200/400)
      final responseData = await Http.put(endpoint, {}); // PUT requests often send an empty body

      if (responseData['status'] == 'success') {
        setState(() {
          _statusMessage = 'Claim successfully ${isApproval ? 'approved' : 'rejected'}.';
        });
        // Navigate back after a short delay to see the change reflected in the list
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
      debugPrint('Claim Action Error: $_statusMessage');
    } finally {
      if(mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final bool hasImage = widget.claim.itemImageBytes.isNotEmpty;

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      appBar: AppBar(
        title: const Text('Review Pending Claim'),
        backgroundColor: isDark ? CustomColors.darkBackground :CustomColors.lightBackground,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Status Message Display ---
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

            // --- Section 1: Item Visual Confirmation (New) ---
            const Text(
              'Item Visual Confirmation',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomColors.primary),
            ),
            const SizedBox(height: 16),
            _buildImageDisplayCard(hasImage, widget.claim.itemImageBytes),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),

            // --- Section 2: Claimer and Justification Details ---
            const Text(
              'Claimer Details & Justification',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomColors.primary),
            ),
            const SizedBox(height: 16),
            
            // Claim Detail Card
            _buildClaimDetailSection(isDark, claim: widget.claim),

            const SizedBox(height: 32),

            // --- Section 3: Admin Action Buttons ---
            
            // Approve Button
            SizedBox(
              width:double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : () => _updateClaimStatus('approve'),
                icon: _isProcessing ? const SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                ) : const Icon(Icons.check_circle_outline),
                label: Text(_isProcessing ? 'Processing...' : 'APPROVE Claim'), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.success,
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
                onPressed: _isProcessing ? null : () => _updateClaimStatus('reject'),
                icon: const Icon(Icons.cancel_outlined, color: CustomColors.error),
                label: const Text('REJECT Claim', style: TextStyle(color: CustomColors.error)), 
                style: OutlinedButton.styleFrom(
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

  // Helper widget to display the ITEM IMAGE
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

  // Helper widget to display the CLAIM details
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
          // Item Name
          Text(
            'Item: ${claim.itemName}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          
          // Claimer Username (NEW)
          _buildInfoRow(Icons.person, 'Claimer: ${claim.username}', isDark),
          
          // Claim ID and Item ID
          _buildInfoRow(Icons.numbers, 'Claim ID: ${claim.id} (Item ID: ${claim.itemId})', isDark),
          
          // Date Claimed
          _buildInfoRow(Icons.calendar_today, 'Date Claimed: ${claim.dateString} at ${claim.timeString}', isDark),
          
          const Divider(height: 24),

          // Claimer Justification/Message (Highlighted)
          const Text(
            'Claimer Justification:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.warning),
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

  // Helper widget to display a single row of info
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