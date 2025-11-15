import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Claims/pending_claim_model.dart';
import 'package:ned_finder/features/Admin/Pending_Claims/widgets/view_response_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';

class AdminPendingClaimsCard extends StatelessWidget {
  final PendingClaimModel claim;
  final VoidCallback onClaimProcessed; // Callback to refresh the parent list

  const AdminPendingClaimsCard({
    super.key,
    required this.claim,
    required this.onClaimProcessed,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the item image data is valid
    final bool hasImage = claim.itemImageBytes.isNotEmpty;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          // Navigate to the full review screen
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewResponseScreen(claim: claim),
            ),
          );
          // When returning from ViewResponseScreen, refresh the list
          onClaimProcessed(); 
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Item Image (Utilizing claim.itemImageBytes) ---
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: hasImage
                      ? Image.memory(
                          claim.itemImageBytes,
                          fit: BoxFit.cover,
                          // Fallback in case of decoding error
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.broken_image, size: 40)),
                        )
                      : Container(
                          color: CustomColors.info.withOpacity(0.1),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported_outlined, color: CustomColors.info),
                                Text('No Item Image', style: TextStyle(color: CustomColors.info, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // --- Claim/Item Name ---
              Text(
                claim.itemName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // --- Claimer Username (Utilizing claim.username) ---
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: CustomColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Claimer: ${claim.username}',
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // --- Claim Date ---
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: CustomColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${claim.dateString} ${claim.timeString}',
                    style: const TextStyle(fontSize: 13, color: CustomColors.textSecondary),
                  ),
                ],
              ),
              const Spacer(),

              // --- Status Tag ---
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    claim.status.toUpperCase(),
                    style: const TextStyle(
                      color: CustomColors.warning,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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