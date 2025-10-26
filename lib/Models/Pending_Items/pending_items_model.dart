import 'dart:ui';

class PendingItemModel {
  final String title;
  final String description;
  final String date;
  final String location;
  final String imageUrl; // Placeholder for image path
  final Color statusColor;
  
  PendingItemModel({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.statusColor,
  });
}