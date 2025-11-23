import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

enum ItemStatus { found, missing }

class LostItemModel {
  final int id;
  final int userId; 

  final String submitterName; 
  final String name;
  final String description;
  final String location;
  final String itemType; 
  final String status;    
  final DateTime dateSubmitted; 
  final String imageBase64; 

  LostItemModel({
    required this.id,
    required this.userId,
    this.submitterName = '',
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
      debugPrint('Error decoding Base64 image: $e');
      return Uint8List(0);
    }
  }

  String get dateFound => '${dateSubmitted.year}-${dateSubmitted.month.toString().padLeft(2, '0')}-${dateSubmitted.day.toString().padLeft(2, '0')}';

  String get timeFound => '${dateSubmitted.hour.toString().padLeft(2, '0')}:${dateSubmitted.minute.toString().padLeft(2, '0')}';

  ItemStatus get itemStatusEnum => itemType == 'found' ? ItemStatus.found : ItemStatus.missing;



  factory LostItemModel.fromJson(Map<String, dynamic> json) {
    final dateString = json['created_at'] ?? json['date'] ?? ''; 
    final parsedDate = DateTime.tryParse(dateString) ?? DateTime.now();
    
    final String submitterName = json['submitter_name'] ?? 'User ${json['user_id']}';

    return LostItemModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      submitterName: submitterName, 
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