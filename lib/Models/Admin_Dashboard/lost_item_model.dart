// lib/models/item_model.dart (or where your model is located)

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
// Assume CustomColors is imported correctly

enum ItemStatus { found, missing }

class LostItemModel {
  final int id;
  final int userId; 
  // ADDED: Simple field for submitterName, initialized to an empty string.
  // This helps when the data is not joined in the API response.
  final String submitterName; 
  final String name;
  final String description;
  final String location;
  final String itemType; // 'lost' or 'found'
  final String status;    // 'pending', 'approved', 'rejected'
  final DateTime dateSubmitted; // Holds the date/time from 'created_at' or 'date'
  final String imageBase64; 

  LostItemModel({
    required this.id,
    required this.userId,
    // Note: We MUST include submitterName in the constructor if it's a field
    this.submitterName = '', // Default to empty string 
    required this.name,
    required this.description,
    required this.location,
    required this.itemType,
    required this.status,
    required this.dateSubmitted,
    required this.imageBase64,
  });

  // --- Getters for UI Display ---

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


  // --- Factory Constructor for JSON Deserialization ---

  factory LostItemModel.fromJson(Map<String, dynamic> json) {
    // We use the more accurate 'created_at' if 'date' is just '00:00:00' (as seen in your samples)
    final dateString = json['created_at'] ?? json['date'] ?? ''; 
    final parsedDate = DateTime.tryParse(dateString) ?? DateTime.now();
    
    // If you modify the FastAPI endpoint to join the 'users' table, 
    // you would access the name here: json['user']['fullname']
    final String submitterName = json['submitter_name'] ?? 'User ${json['user_id']}';

    return LostItemModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      submitterName: submitterName, // Use the extracted name/placeholder
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