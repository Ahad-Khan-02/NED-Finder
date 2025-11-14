// item_model.dart

import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart'; // Assuming this provides CustomColors

class ItemModel {
  // Ensure fields are non-nullable by providing required defaults in the constructor
  final int id;
  final int userId;
  final String itemType;
  final String name; 
  final String description; 
  final String email;
  final DateTime date; 
  final String location;
  final bool isFound; 
  final String status;
  final DateTime createdAt; 
  final String imageBase64; 
  
  // --- Computed Properties for UI ---
  
  // Uses base64Decode safely
  Uint8List get imageBytes {
    try {
      return base64Decode(imageBase64);
    } catch (e) {
      // Return an empty list if decoding fails
      return Uint8List(0);
    }
  }

  // Uses safe status string (guaranteed non-null by fromJson)
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'approved':
        return CustomColors.success;
      case 'pending':
        return CustomColors.warning;
      case 'rejected':
        return CustomColors.error;
      default:
        return Colors.grey;
    }
  }

  String get statusText {
    return status.toUpperCase();
  }

  // --- Helper Getters for Item Type ---
  String get labelText => itemType == 'found' ? 'Found' : 'Missing';
  
  Color get labelColor => itemType == 'found' ? CustomColors.success : CustomColors.error;
  
  String get dateLabel => itemType == 'found' ? 'Date Found' : 'Date Lost';
  
  String get locationLabel => itemType == 'found' ? 'Location Found' : 'Location Lost';

  // --- Date/Time Helpers ---
  String get dateString => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  String get timeString => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';


  ItemModel({
    required this.id,
    required this.userId,
    required this.itemType,
    required this.name,
    required this.description,
    required this.email,
    required this.date,
    required this.location,
    required this.isFound,
    required this.status,
    required this.createdAt,
    required this.imageBase64,
  });

  // --- Null-Safe JSON Factory Constructor ---
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    
    // 1. Image Base64 Extraction (Null-safe and splits off data URI headers)
    final String fullImageString = json['item_image'] as String? ?? '';
    final String base64Data = fullImageString.split(',').last.trim();

    // 2. Field Extraction with Null Safety (using ?? to provide defaults)
    
    // Safety for DateTimes
    final DateTime safeDate = DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now();
    final DateTime safeCreatedAt = DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now();

    return ItemModel(
      // Numbers (use ?? 0)
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      
      // Strings (use ?? 'N/A' or a contextual default)
      itemType: json['item_type'] as String? ?? 'lost', // Default to 'lost'
      name: json['item_name'] as String? ?? 'Unnamed Item',
      description: json['item_description'] as String? ?? 'No description provided.',
      email: json['email'] as String? ?? 'user@example.com',
      location: json['location'] as String? ?? 'Unknown Location',
      status: json['status'] as String? ?? 'pending', // Default status to prevent UI crash
      
      // Booleans (use ?? false)
      isFound: json['found'] as bool? ?? false,

      // DateTimes (use safe, parsed values)
      date: safeDate,
      createdAt: safeCreatedAt,

      // Base64
      imageBase64: base64Data, 
    );
  }
}