import 'dart:convert';
import 'dart:typed_data';

class PendingClaimModel {
  final int id; // Claim ID
  final int userId; // The ID of the user making the claim
  final String username; // NEW: The username of the claimer
  final int itemId; // The ID of the item being claimed
  final String itemName;
  final String claimMessage;
  final String itemImageBase64;
  final String status; 
  final DateTime createdAt;

  PendingClaimModel({
    required this.id,
    required this.userId,
    required this.username, 
    required this.itemId,
    required this.itemName,
    required this.claimMessage,
    required this.itemImageBase64, 
    required this.status,
    required this.createdAt,
  });


  // Separates Date
  String get dateString => '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';

  // Separates Time
  String get timeString => '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  
  Uint8List get itemImageBytes {
    try {
      String base64String = itemImageBase64.split(',').last;
      return base64Decode(base64String);
    } catch (e) {
      print('Error decoding Base64 image: $e');
      return Uint8List(0); 
    }
  }


  factory PendingClaimModel.fromJson(Map<String, dynamic> json) {
    final dateString = json['created_at'] ?? ''; 
    final parsedDate = DateTime.tryParse(dateString) ?? DateTime.now();

    return PendingClaimModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      username: json['username'] ?? 'Unknown User', 
      itemId: json['item_id'] as int? ?? 0,
      itemName: json['item_name'] ?? 'Unknown Item',
      claimMessage: json['claim_message'] ?? 'No claim message provided.',
      itemImageBase64: json['item_image'] ?? '', 
      status: json['status'] ?? 'pending',
      createdAt: parsedDate,
    );
  }
}