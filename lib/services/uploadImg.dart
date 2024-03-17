import 'dart:io';

import 'package:image_picker/image_picker.dart';

class uploadMethods {
  File? _imageFile;
  ImagePicker _imagePicker = ImagePicker();
  Future<File?> _pickImage() async {
    XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _imageFile = File(pickedImage.path);
    }

    return _imageFile;
  }
}
