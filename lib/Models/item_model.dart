// lib/models/item_model.dart

import 'package:flutter/material.dart';
// Assuming this is correctly imported for CustomColors
import 'package:ned_finder/utils/constants/colors.dart'; 

enum ItemStatus { found, missing }

class ItemModel {
  final String id;
  final int userId; // 🚨 ADDED: To match the 'user_id' in JSON
  final String name;
  final String category;
  final DateTime date;
  final String location;
  final String description;
  final String imageUrl; // Note: Your JSON doesn't have 'imageUrl', using a placeholder
  final ItemStatus status;

  ItemModel({
    required this.id,
    required this.userId, // 🚨 ADDED
    required this.name,
    required this.category,
    required this.date,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.status,
  });

  // 🚀 CRITICAL ADDITION: Factory constructor for JSON deserialization
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    // Determine status based on the 'found' boolean field
    final bool isFound = json['found'] ?? false;
    final ItemStatus status = isFound ? ItemStatus.found : ItemStatus.missing;

    // Use a date field that includes the time for better accuracy
    final String dateString = json['created_at'] ?? json['date'] ?? DateTime.now().toIso8601String();

    return ItemModel(
      // Safely convert int ID to String
      id: json['id']?.toString() ?? '0', 
      // Safely access and cast userId
      userId: json['user_id'] as int? ?? 0, 
      name: json['item_name'] ?? 'Unknown Item',
      // Category is not in JSON, using a hardcoded default
      category: 'General Item', 
      // Parse the date string
      date: DateTime.parse(dateString), 
      location: json['location'] ?? 'Unknown Location',
      description: json['item_description'] ?? 'No description.',
      // Image URL is missing from JSON, use a placeholder
      imageUrl: json['item_image'] ?? 'assets/images/placeholder.jpg', 
      status: status,
    );
  }

  // Helper getter for UI
  String get statusText => status == ItemStatus.found ? 'Found' : 'Missing';
  Color get statusColor => status == ItemStatus.found ? CustomColors.success : CustomColors.error;
  String get dateLabel => status == ItemStatus.found ? 'Date Found' : 'Date Lost';
  String get locationLabel => status == ItemStatus.found ? 'Location Found' : 'Location Lost';
}