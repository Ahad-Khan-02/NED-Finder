import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart'; // Assuming this provides CustomColors

class ItemModel {
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
  

  Uint8List get imageBytes {
    try {
      return base64Decode(imageBase64);
    } catch (e) {
      return Uint8List(0);
    }
  }

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

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    
    final String fullImageString = json['item_image'] as String? ?? '';
    final String base64Data = fullImageString.split(',').last.trim();

    
    // Safety for DateTimes
    final DateTime safeDate = DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now();
    final DateTime safeCreatedAt = DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now();

    return ItemModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      
      itemType: json['item_type'] as String? ?? 'lost', 
      name: json['item_name'] as String? ?? 'Unnamed Item',
      description: json['item_description'] as String? ?? 'No description provided.',
      email: json['email'] as String? ?? 'user@example.com',
      location: json['location'] as String? ?? 'Unknown Location',
      status: json['status'] as String? ?? 'pending',   
      isFound: json['found'] as bool? ?? false,
      date: safeDate,
      createdAt: safeCreatedAt,
      imageBase64: base64Data, 
    );
  }
}