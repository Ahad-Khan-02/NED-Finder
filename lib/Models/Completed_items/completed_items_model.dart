import 'dart:convert';
import 'dart:typed_data';

enum ItemStatus { lost, found }

class CompletedItemModel {
  final int id;
  final int userId; 
  final String submitterName; // Placeholder
  final String name;
  final String description;
  final String location;
  final String itemType; // 'lost' or 'found'
  final String status;  // Should be 'approved' or 'completed'
  final DateTime dateSubmitted;
  final String imageBase64; 
  final bool isFound; // NEW: Maps the 'found' field

  CompletedItemModel({
    required this.id,
    required this.userId,
    required this.submitterName,
    required this.name,
    required this.description,
    required this.location,
    required this.itemType,
    required this.status,
    required this.dateSubmitted,
    required this.imageBase64,
    required this.isFound, // NEW
  });

  // --- Getters for UI Display ---
  
  // Decodes Base64 string to a displayable byte array for Image.memory
  Uint8List get imageBytes {
    try {
      final cleanBase64 = imageBase64.replaceAll('\n', '').replaceAll('\r', '').trim();
      if (cleanBase64.isEmpty) return Uint8List(0);
      return base64Decode(cleanBase64);
    } catch (e) {
      return Uint8List(0);
    }
  }

  // Separates Date
  String get dateString => '${dateSubmitted.year}-${dateSubmitted.month.toString().padLeft(2, '0')}-${dateSubmitted.day.toString().padLeft(2, '0')}';

  // Separates Time
  String get timeString => '${dateSubmitted.hour.toString().padLeft(2, '0')}:${dateSubmitted.minute.toString().padLeft(2, '0')}';


  // --- Factory Constructor for JSON Deserialization ---

  factory CompletedItemModel.fromJson(Map<String, dynamic> json) {
    // We prefer 'created_at' if available for accurate submission time
    final dateString = json['created_at'] ?? json['date'] ?? ''; 
    final parsedDate = DateTime.tryParse(dateString) ?? DateTime.now();
    
    // Placeholder for submitter name
    final String submitterName = json['submitter_name'] ?? 'User ID: ${json['user_id']}';

    return CompletedItemModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      submitterName: submitterName, 
      name: json['item_name'] ?? 'Unknown Item',
      description: json['item_description'] ?? 'No description.',
      location: json['location'] ?? 'Unknown Location',
      itemType: json['item_type'] ?? 'lost',
      status: json['status'] ?? 'approved', // Default status for this screen
      dateSubmitted: parsedDate,
      imageBase64: json['item_image'] ?? '', 
      isFound: json['found'] as bool? ?? false, // Mapped directly from the 'found' API field
    );
  }
}