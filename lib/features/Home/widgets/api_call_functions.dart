import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';


Future<bool?> showConfirmationDialog(
  BuildContext context,
  String title,
  String content,
  Color buttonColor,
) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: Text(title.contains('Delete') ? 'Delete' : 'Confirm',style: TextStyle(color:buttonColor),),
          )
        ],
      );
    },
  );
}


Future<void> editItemApiCall({
  required BuildContext sheetContext,
  required BuildContext screenContext,
  required ItemModel originalItem,
  required String name,
  required String description,
  required String location,
  Uint8List? newImageBytes,      
  String? newImageMimeType,        
}) async {
  
  HelperFunctions.showSnackBar('Sending update request...');

  final endpoint = 'items/${originalItem.id}/edit';

  final Map<String, String> fields = {
    'user_id': originalItem.userId.toString(),
    'item_name': name,
    'item_description': description,
    'location': location,
  };

  try {

    final responseData = await Http.put(
      endpoint,
      data: fields,
      isMultipart: newImageBytes != null,       
      fileBytes: newImageBytes != null ? newImageBytes : null,             
      fileFieldName: newImageBytes != null ? 'item_image' : null,
      fileName: newImageBytes != null
          ? '${originalItem.id}_${DateTime.now().millisecondsSinceEpoch}.${newImageMimeType?.split('/').last ?? 'jpg'}'
          : null,
      fileMimeType: newImageMimeType,
    );

    if (responseData['status'] == 'success') {
      print('');
      HelperFunctions.showSnackBar('Item "$name" successfully updated!');
      Navigator.of(sheetContext).pop();
      Navigator.of(screenContext).pop(true); // signal parent to refresh
    } else {
      HelperFunctions.showSnackBar(
          responseData['message'] ?? 'Failed to update item.');
    }
  } catch (e) {
    HelperFunctions.showSnackBar('Connection error during update: $e');
  }
}


/// Handles the API call to delete an item.
Future<void> deleteItemApiCall(BuildContext context, ItemModel item) async {
  final bool confirm = await showConfirmationDialog(
    context,
    'Delete Item',
    'Are you sure you want to permanently delete this item?',
    CustomColors.error,
  ) ?? false;

  if (!confirm) return;

  HelperFunctions.showSnackBar('Requesting item deletion...');

  final endpoint = 'items/${item.id}?user_id=${item.userId}';

  try {
    final responseData = await Http.delete(endpoint);

    if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
      HelperFunctions.showSnackBar('Item "${item.name}" successfully deleted!');
      
      Navigator.of(context).pop(true); 
    } else {
      HelperFunctions.showSnackBar(
        (responseData is Map<String, dynamic> && responseData.containsKey('message'))
            ? responseData['message']
            : 'Failed to delete item.',
      );
    }
  } catch (e) {
    HelperFunctions.showSnackBar('Connection error during deletion: $e');
  }
}

Future<void> markAsFoundApiCall(BuildContext context, ItemModel item) async {
  final bool confirm = await showConfirmationDialog(
    context,
    'Mark as Found',
    'Are you sure you want to mark this item as found and close the listing?',
    CustomColors.primary
  ) ?? false;

  if (!confirm) return;

  HelperFunctions.showSnackBar('Marking item as found...');

  final endpoint = 'items/${item.id}/found?user_id=${item.userId}';

  try {
    final responseData = await Http.put(endpoint);

    if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
      HelperFunctions.showSnackBar('Item "${item.name}" marked as found!');

      Navigator.of(context).pop(true); 
    } else {
      HelperFunctions.showSnackBar(
        (responseData is Map<String, dynamic> && responseData.containsKey('message'))
            ? responseData['message']
            : 'Failed to mark item as found.',
      );
    }
  } catch (e) {
    HelperFunctions.showSnackBar('Connection error while marking as found: $e');
  }
}