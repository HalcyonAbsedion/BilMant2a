import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class uploadMethods {
  // File? _imageFile;
  // ImagePicker _imagePick = ImagePicker();
  // Future<File?> _pickImage() async {
  //   XFile? pickedImage =
  //       await _imagePick.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     _imageFile = File(pickedImage.path);
  //   }

  //   return _imageFile;
  // }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);

    return result!;
  }

  final currentUser = FirebaseAuth.instance.currentUser!;
  Future<void> updateUserImage(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update({
        'photoUrl': imageUrl,
      });
    } catch (error) {
      print('Error updating user image: $error');
      throw error;
    }
  }

  Future<String> uploadFile(String path) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${DateTime.now().toIso8601String() + p.basename(path)}');

      final result = await ref.putFile(File(path));
      final fileUrl = await result.ref.getDownloadURL();
      updateUserImage(fileUrl);

      return fileUrl;
    } catch (error) {
      // Handle any errors that occur during the file upload process
      print('Error uploading file: $error');
      // Optionally, you can throw the error to propagate it to the caller
      throw error;
    }
  }

  final ImageCropper _imageCropper = ImageCropper();
  var file;
  final ImagePicker _imagePicker = ImagePicker();

  Future picksImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedFile == null) {
      return;
    }

    file = await _imageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (file == null) {
      return;
    }

    file = (await compressImage(file.path, 35));

    await uploadFile(file.path);
  }
}
