import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  // User went into the gallery and didn't select any image and came back
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image is selected');
}
