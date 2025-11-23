import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';

class AdminItemDetailsScreen extends StatefulWidget {
  const AdminItemDetailsScreen({
    super.key,
    required this.item,
    required this.onUpdate, 
  });

  final PendingItemModel item;
  final VoidCallback onUpdate;

  @override
  State<AdminItemDetailsScreen> createState() => _AdminItemDetailsScreenState();
}

class _AdminItemDetailsScreenState extends State<AdminItemDetailsScreen> {
  bool _isLoading = false;


  Future<void> _approveItem() async {
    setState(() => _isLoading = true);
    try {
      final responseData = await Http.post('items/approve/${widget.item.id}', {});

      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item approved successfully!')),
        );
        widget.onUpdate(); // Trigger parent widget to refresh list
        Navigator.pop(context); // Go back to the list screen
      } else {
        throw Exception(responseData['message'] ?? 'Failed to approve item.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving item: ${e.toString()}')),
      );
      debugPrint('Approval Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Item Approval'),
          content: Text('Are you sure you want to approve the item: "${widget.item.name}"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Cancel', style: TextStyle(color:  CustomColors.darkerGrey)),
            ),
            TextButton(onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                _approveItem(); // Proceed with the approval
              }, child: const Text('Approve', style: TextStyle(color: CustomColors.primary)),
            )
          ]
        );
      },
    );
  }


  Future<void> _submitReject(String reason) async {
    setState(() => _isLoading = true);
    try {
      final uri = 'items/reject/${widget.item.id}';
      
      final responseData = await Http.multipartPost(
        uri, 
        {"reason": reason}, 
        null, 
        'no_file', 
      );

      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item rejected successfully!')),
        );
        widget.onUpdate();
        Navigator.pop(context); 
      } else {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      debugPrint('Rejection Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  void _openRejectBottomSheet() {
    final TextEditingController reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: HelperFunctions.isDarkMode(context)? CustomColors.dark : CustomColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                CustomTexts.reasonForRejection,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: CustomTexts.reasonForRejectionHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    final reason = reasonController.text.trim();
                    if (reason.isEmpty) {
                      HelperFunctions.showAlert('Reason Required', 'Please provide a reason before submitting.');
                      return;
                    }
                    Navigator.pop(context); 
                    _submitReject(reason); 
                  },
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text(CustomTexts.submitRejection),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String text, {int maxLines = 10}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: CustomColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CustomColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: const TextStyle(fontSize: 14),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (Full Width)
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: item.imageBytes.isNotEmpty ? null : Colors.grey.shade300,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.imageBytes.isNotEmpty
                    ? Image.memory(item.imageBytes, fit: BoxFit.cover)
                    : Center(
                        child: Icon(Icons.photo, color: Colors.blueGrey.shade400, size: 60),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Item Type Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: item.itemType == 'lost' ? CustomColors.error.withOpacity(0.1) : CustomColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.itemType.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: item.itemType == 'lost' ? CustomColors.error : CustomColors.success,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Details Section
            _buildDetailRow(Icons.person, item.submitterName,'' ),
            _buildDetailRow(Icons.calendar_today, 'Date/Time', '${item.dateString} at ${item.timeString}'),
            _buildDetailRow(Icons.location_on, 'Location', item.location),
            _buildDetailRow(Icons.description, 'Description', item.description, maxLines: 5),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primary,
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Approve', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _openRejectBottomSheet,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: CustomColors.error.withOpacity(0.1),
                      foregroundColor: CustomColors.error,
                      side: const BorderSide(color: CustomColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Reject', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}