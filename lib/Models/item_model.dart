// lib/models/item_model.dart

import 'package:flutter/material.dart';
import 'package:ned_finder/utils/constants/colors.dart';

enum ItemStatus { found, missing }

class ItemModel {
  final String id;
  final String name;
  final String category;
  final DateTime date;
  final String location;
  final String description;
  final String imageUrl;
  final ItemStatus status;

  ItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.status,
  });

  // Helper getter for UI
  String get statusText => status == ItemStatus.found ? 'Found' : 'Missing';
  Color get statusColor => status == ItemStatus.found ? CustomColors.success : CustomColors.error;
  String get dateLabel => status == ItemStatus.found ? 'Date Found' : 'Date Lost';
  String get locationLabel => status == ItemStatus.found ? 'Location Found' : 'Location Lost';
}