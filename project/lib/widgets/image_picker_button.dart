import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerButton extends StatelessWidget {
  final Function(File) onImagePicked;

  const ImagePickerButton({required this.onImagePicked});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final image = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          onImagePicked(File(image.path));
        }
      },
      child: Icon(Icons.upload),
    );
  }
}