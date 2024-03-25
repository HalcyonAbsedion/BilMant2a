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
    // Initialize with a required AssetEntity
    required this.assetEntity,
    // Initialize with a required Widget
    required this.widget,
  });
  Future<String?> getFilePath() async {
    // Retrieve the file associated with the asset
    File? file = await assetEntity.file;
    // Check if the file is not null
    if (file != null) {
      // Return the file path
      return file.path;
    }
    // If file is null, return null
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

  Future<void> uploadToFirebaseStorage() async {
    // Get the file path
    String? filePath = await getFilePath();
    if (filePath == null) {
      print('File Path is null. Cannot upload to Firebase Storage.');
      return;
    }

    // Initialize Firebase Storage instance
    FirebaseStorage storage = FirebaseStorage.instance;

    // Create a reference to the file in Firebase Storage
    Reference ref =
        storage.ref().child('image/${DateTime.now().millisecondsSinceEpoch}');

    try {
      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(File(filePath));
      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;
      // Get the download URL of the uploaded file
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // uploadMethods().updateUserImage(downloadURL);
      print('File uploaded to Firebase Storage. Download URL: $downloadURL');
    } catch (e) {
      print('Error uploading file to Firebase Storage: $e');
    }
  }
}
