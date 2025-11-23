import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ned_finder/Models/item_model.dart';
import 'package:ned_finder/features/Home/view_item_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

typedef ItemSaveCallback = void Function(
    BuildContext sheetContext, 
    BuildContext screenContext, 
    String name,
    String description,
    String location,
    Uint8List? newImageBytes,
    String? newImageMimeType);


class EditItemForm extends StatefulWidget {
  final ItemModel item;
  final ItemSaveCallback onSave;

  const EditItemForm({super.key, required this.item, required this.onSave});

  @override
  State<EditItemForm> createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  bool _isLoading = false;

  Uint8List? _newImageBytes;
  String? _newImageMimeType;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _descriptionController = TextEditingController(text: widget.item.description);
    _locationController = TextEditingController(text: widget.item.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  
  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;
    
    final file = File(image.path);
    final bytes = await file.readAsBytes();

    setState(() {
      _pickedImage = file;
      _newImageBytes = bytes;
      _newImageMimeType = image.mimeType; 
    });
  }

  void _submitForm(BuildContext sheetContext, BuildContext screenContext) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      widget.onSave(
        sheetContext,
        screenContext,
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        _locationController.text.trim(),
        _newImageBytes, 
        _newImageMimeType, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ViewItemScreen? parentWidget = context.findAncestorWidgetOfExactType<ViewItemScreen>();
    final BuildContext screenContext = parentWidget != null ? context : context; 

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  CustomTexts.editItemTitle,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 20),
            const SizedBox(height: 15),

            // Item Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
              validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
            ),
            const SizedBox(height: 15),

            // Item Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
            ),
            const SizedBox(height: 15),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location Found/Lost'),
              validator: (value) => value!.isEmpty ? 'Location cannot be empty' : null,
            ),
            const SizedBox(height: 15),
            
            // Change Image Button
            OutlinedButton.icon(
              onPressed: _uploadImage,
              icon: _pickedImage != null
                  ? const Icon(Icons.check_circle_outline, color: Colors.green)
                  : const Icon(Icons.cloud_upload),
              label: Text(
                _pickedImage != null
                    ? 'Image Selected: ${Uri.file(_pickedImage!.path).pathSegments.last}'
                    : 'Change Image',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: _pickedImage != null
                    ? const BorderSide(color: Colors.green, width: 2)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),

            if (_pickedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _pickedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 15),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pickedImage == null ? ()=>HelperFunctions.showAlert('','Please select an image') :_isLoading ? null : () =>  _submitForm(context, screenContext),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.primary,
                  foregroundColor: Colors.white,
                  side: BorderSide(color: CustomColors.primary)
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(CustomTexts.saveChanges, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}