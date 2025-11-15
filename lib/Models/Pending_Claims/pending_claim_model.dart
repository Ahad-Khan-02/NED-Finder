import 'dart:convert';
import 'dart:typed_data';

// This model represents a specific claim request pending review from an Admin.
class PendingClaimModel {
  final int id; // Claim ID
  final int userId; // The ID of the user making the claim
  final String username; // NEW: The username of the claimer
  final int itemId; // The ID of the item being claimed
  final String itemName;
  final String claimMessage;
  final String itemImageBase64; // NEW: Base64 string of the item's image
  final String status; // Expected to be 'pending'
  final DateTime createdAt;

  PendingClaimModel({
    required this.id,
    required this.userId,
    required this.username, // Added to constructor
    required this.itemId,
    required this.itemName,
    required this.claimMessage,
    required this.itemImageBase64, // Added to constructor
    required this.status,
    required this.createdAt,
  });

  // --- Getters for UI Display ---

  // Separates Date
  String get dateString => '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';

  // Separates Time
  String get timeString => '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  
  // Converts the Base64 string into a Uint8List for display in Flutter's Image.memory
  Uint8List get itemImageBytes {
    try {
      // Remove any data URL prefix (like "data:image/jpeg;base64,") before decoding
      String base64String = itemImageBase64.split(',').last;
      return base64Decode(base64String);
    } catch (e) {
      // Return an empty list or handle the error gracefully if the string is invalid
      print('Error decoding Base64 image: $e');
      return Uint8List(0); 
    }
  }


  // --- Factory Constructor for JSON Deserialization ---

  factory PendingClaimModel.fromJson(Map<String, dynamic> json) {
    final dateString = json['created_at'] ?? ''; 
    final parsedDate = DateTime.tryParse(dateString) ?? DateTime.now();

    return PendingClaimModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      username: json['username'] ?? 'Unknown User', // New field
      itemId: json['item_id'] as int? ?? 0,
      itemName: json['item_name'] ?? 'Unknown Item',
      claimMessage: json['claim_message'] ?? 'No claim message provided.',
      itemImageBase64: json['item_image'] ?? '', // New field
      status: json['status'] ?? 'pending',
      createdAt: parsedDate,
    );
  }
}