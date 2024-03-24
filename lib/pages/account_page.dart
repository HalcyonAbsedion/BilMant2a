import 'dart:io';

import 'package:bilmant2a/pages/profile_edit.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/uploadImg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:bilmant2a/services/auth_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthMethods _authMethods = AuthMethods();
  final uploadMethods _uploadMethods = uploadMethods();
  @override
  void initState() {
    super.initState();
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

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
                      _uploadMethods.picksImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Choose a File"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _uploadMethods.picksImage(ImageSource.gallery);
                    },
                  )
                ],
              ),
              onClosing: () {},
            ));
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _authMethods.signOut();
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
                      backgroundImage: userProvider.getUser.photoUrl != ""
                          ? NetworkImage(userProvider.getUser.photoUrl)
                          : null,
                      // Optionally, you can provide a placeholder image here
                      // Placeholder can be a default user avatar or a loading indicator
                      // backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : AssetImage('assets/default_avatar.png'),
                    ),
                  )
                ],
              ),
              Text(
                "${userProvider.getUser.firstName} ${userProvider.getUser.lastName}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Bio: ${userProvider.getUser.bio} ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoColumn(
                    "16",
                    "Friends",
                  ),
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
