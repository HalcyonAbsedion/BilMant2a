import 'dart:io';

import 'package:bilmant2a/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class postCreationPage extends StatefulWidget {
  const postCreationPage({super.key});

  @override
  State<postCreationPage> createState() => _postCreationPageState();
}

class _postCreationPageState extends State<postCreationPage> {
  XFile? pickedFile;
  final user = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  String selectedPostType = 'explore';
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
                    onTap: () async {
                      Navigator.of(context).pop();

                      pickedFile = await _imagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 50,
                      );

                      if (pickedFile == null) {
                        return;
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Choose a File"),
                    onTap: () async {
                      Navigator.of(context).pop();

                      pickedFile = await _imagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50,
                      );

                      if (pickedFile == null) {
                        return;
                      }
                    },
                  )
                ],
              ),
              onClosing: () {},
            ));
  }

  void postSend(String selectedPostType) {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'PostType': selectedPostType, // New field for post type
      });
    }

    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Post to"),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                "Post",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ))
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: userProvider.getUser.photoUrl != ""
                    ? NetworkImage(userProvider.getUser.photoUrl)
                    : null,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              // SizedBox(
              //   height: 45,
              //   width: 45,
              //   child: AspectRatio(
              //     aspectRatio: 487 / 451,
              //     child: Container(
              //       decoration: BoxDecoration(
              //           image: DecorationImage(
              //         image: NetworkImage(userProvider.getUser.photoUrl),
              //         fit: BoxFit.fill,
              //         alignment: FractionalOffset.topCenter,
              //       )),
              //     ),
              //   ),
              // ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedPostType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPostType = newValue!;
                    });
                  },
                  items: <String>['explore', 'donations', 'volunteer']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Divider()
            ],
          ),
          GestureDetector(
            onTap: _selectPhoto,
            child: Container(
              width: 200,
              height: 200,
              color: Colors.grey[200],
              child: pickedFile == null
                  ? Center(child: Icon(Icons.camera_alt, size: 50))
                  : Image.file(
                      File(pickedFile!.path),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
