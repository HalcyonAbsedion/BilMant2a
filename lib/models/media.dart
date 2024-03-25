import 'dart:io';

import 'package:bilmant2a/services/uploadImg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

// Define a class to hold media assets and corresponding widgets
class Media {
  // Represents a media asset managed by photo_manager
  final AssetEntity assetEntity;
  // Represents a Flutter widget associated with the asset
  final Widget widget;
  Media({
    required this.assetEntity,
    required this.widget,
  });
  Future<String?> getFilePath() async {
    File? file = await assetEntity.file;
    if (file != null) {
      return file.path;
    }
    return null;
  }

  Future<void> printFilePath() async {
    String? filePath = await getFilePath();
    if (filePath != null) {
      print('File Path: $filePath');
    } else {
      print('File Path is null');
    }
  }

  Future<String?> uploadToFirebaseStorage() async {
    // Get the file path
    String? filePath = await getFilePath();
    if (filePath == null) {
      print('File Path is null. Cannot upload to Firebase Storage.');
      return "";
    }

    // Initialize Firebase Storage instance
    FirebaseStorage storage = FirebaseStorage.instance;

    // Create a reference to the file in Firebase Storage
    Reference ref =
        storage.ref().child('postMedia/${DateTime.now().millisecondsSinceEpoch}');

    try {
      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(File(filePath));
      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;
      // Get the download URL of the uploaded file
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // uploadMethods().updateUserImage(downloadURL);

      print('File uploaded to Firebase Storage. Download URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading file to Firebase Storage: $e');
    }
  }
}
