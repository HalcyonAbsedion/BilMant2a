// ignore_for_file: prefer_const_constructors

import 'package:bilmant2a/components/editField.dart';
import 'package:bilmant2a/providers/post_provider.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/uploadImg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import "package:bilmant2a/models/user.dart" as model;

class ProfilePageEdit extends StatefulWidget {
  const ProfilePageEdit({Key? key}) : super(key: key);

  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  final uploadMethods _uploadMethods = uploadMethods();
  @override
  void initState() {
    super.initState();
  }

  final currentUser = FirebaseAuth.instance.currentUser!;
  Future<void> _updateProviders(
      UserProvider userProvider, PostProvider postProvider) async {
    // Update user provider
    await userProvider.refreshUser();

    // Update posts with user's profile image
    final List postIds = userProvider.getUser.postIds;
    final String profileImg = userProvider.getUser.photoUrl;
    for (var postId in postIds) {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection("Posts").doc(postId);
      await postRef.update({'profImage': profileImg});
    }

    // Fetch updated posts
    await postProvider.fetchPosts();
    await postProvider
        .fetchCurrentUserFilteredPosts(userProvider.getUser.postIds);
  }

  Future<void> _selectPhoto() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);

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
                await _uploadMethods.picksImage(ImageSource.camera);
                // Update providers after selecting image
                await _updateProviders(userProvider, postProvider);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Choose a File"),
              onTap: () async {
                Navigator.of(context).pop();
                await _uploadMethods.picksImage(ImageSource.gallery);
                // Update providers after selecting image
                await _updateProviders(userProvider, postProvider);
              },
            ),
          ],
        ),
        onClosing: () {},
      ),
    );
  }

  final usersColl = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    String _selectedGender = "Male";
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 21, 21, 22),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        //background

        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(68, 3, 136, 244),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: _selectPhoto,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.photoUrl != ""
                          ? NetworkImage(user.photoUrl)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: IconButton(
                      onPressed: _selectPhoto,
                      icon: Icon(
                        Icons.edit,
                        size: 43,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                currentUser.email!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              'Feel free to edit your information by pressing the edit icons below...',
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50,
            ),

            //First name
            editField(
              label: "First Name",
              userValue: user.firstName,
              field: "firstName",
            ),
            SizedBox(
              height: 20,
            ),

            //Last name
            editField(
              label: "Last Name",
              userValue: user.lastName,
              field: "lastName",
            ),
            SizedBox(
              height: 20,
            ),

            //age
            editField(
              label: "D.O.B",
              userValue: user.birthDate,
              field: "birthDate",
              isDate: true,
            ),

            SizedBox(
              height: 20,
            ),

            //bio
            editField(
              label: "Bio",
              userValue: user.bio,
              field: "bio",
            ),
            SizedBox(
              height: 20,
            ),
            //gender
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Gender:"),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: false,
                        iconEnabledColor: Colors.cyan,
                        padding: const EdgeInsetsDirectional.only(
                          start: 16.0,
                          end: 16.0,
                        ),
                        value: _selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Do Not Specify']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //phone number
            editField(
              label: "Phone Number",
              userValue: user.phoneNumber,
              field: "phoneNumber",
            ),
          ],
        ));
  }
}
