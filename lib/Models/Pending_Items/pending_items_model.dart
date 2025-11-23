import 'dart:convert';
import 'dart:typed_data';

enum ItemStatus { found, missing }

class PendingItemModel {
  final int id;
  final int userId; 
  final String name;
  final String description;
  final String location;
  final String itemType; 
  final String status;   
  final DateTime dateSubmitted;
  final String imageBase64; 

  PendingItemModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.location,
    required this.itemType,
    required this.status,
    required this.dateSubmitted,
    required this.imageBase64,
  });

  
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


  factory PendingItemModel.fromJson(Map<String, dynamic> json) {
    final dateString = json['created_at'] ?? json['date'] ?? ''; 
    final parsedDate = DateTime.tryParse(dateString) ?? DateTime.now();
    

    return PendingItemModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      name: json['item_name'] ?? 'Unknown Item',
      description: json['item_description'] ?? 'No description.',
      location: json['location'] ?? 'Unknown Location',
      itemType: json['item_type'] ?? 'lost',
      status: json['status'] ?? 'pending',
      dateSubmitted: parsedDate,
      imageBase64: json['item_image'] ?? '', 
    );
  }
}