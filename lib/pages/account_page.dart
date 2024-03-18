import 'dart:io';

import 'package:bilmant2a/pages/profile_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String firstname = "";
  String lastName = "";
  String imageURL = "";

  @override
  void initState() {
    super.initState();

    print("HELEJSLFJSDFDSFSDFDSFDS");
    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser != null) {
      // If authenticated, fetch user data
      getName();
    } else {
      // If not authenticated, handle accordingly
      // For example, navigate back to login screen
      print("User not authenticated");
    }
  }

  void getName() async {
    try {
      print("Current user UID: ${FirebaseAuth.instance.currentUser!.uid}");
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();

      print("Snapshot data: ${snap.data()}");

      if (snap.exists) {
        setState(() {
          firstname = (snap.data() as Map<String, dynamic>)['first name'];
          lastName = (snap.data() as Map<String, dynamic>)['last name'];

          imageURL = (snap.data() as Map<String, dynamic>)['imageURL'] ?? "";
        });
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error retrieving document: $e");
    }
  }

  var file;

  final currentUser = FirebaseAuth.instance.currentUser!;

  final ImagePicker _imagePicker = ImagePicker();

  Future _selectPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _picksImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Choose a File"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _picksImage(ImageSource.gallery);
                    },
                  )
                ],
              ),
              onClosing: () {},
            ));
  }

  final ImageCropper _imageCropper = ImageCropper();

  Future _picksImage(ImageSource source) async {
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

    await _uploadFile(file.path);
  }

  Future<String> _uploadFile(String path) async {
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

  Future<void> updateUserImage(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .update({
        'imageURL': imageUrl,
      });
    } catch (error) {
      print('Error updating user image: $error');
      throw error;
    }
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);

    return result!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
              size: 30,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 300,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.help,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: _selectPhoto,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          imageURL != "" ? NetworkImage(imageURL) : null,
                      // Optionally, you can provide a placeholder image here
                      // Placeholder can be a default user avatar or a loading indicator
                      // backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : AssetImage('assets/default_avatar.png'),
                    ),
                  )
                ],
              ),
              Text(
                "${firstname} ${lastName}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoColumn("16", "Friends"),
                  _buildInfoColumn("16", "Connections"),
                  _buildInfoColumn("16", "Posts"),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: ElevatedButton(
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePageEdit(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    fixedSize: const Size(300, 50),
                    backgroundColor: Colors.grey[300],
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.grey,
                width: double.infinity,
                height: 1,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 0),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
