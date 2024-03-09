import 'package:bilmant2a/components/post.dart';
import 'package:bilmant2a/pages/profile_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _imageFile;

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  Future<List<Map<String, dynamic>>> getUserPosts(String? userEmail) async {
    if (userEmail == null) {
      // Handle the case where userEmail is null
      return [];
    }

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("User Posts")
              .where('UserEmail', isEqualTo: userEmail)
              .get();

      List<Map<String, dynamic>> userPosts =
          querySnapshot.docs.map((doc) => doc.data()).toList();
      return userPosts;
    } catch (error) {
      // Handle any errors that occur during the process
      print("Error fetching user posts: $error");
      return [];
    }
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
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
                Icons.share,
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
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                  ),
                  InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      child: const Icon(
                        Icons.edit,
                        size: 25,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: getUserDetails(),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      Map<String, dynamic>? user = snapshot.data!.data();
                      if (user != null && user.containsKey('first name')) {
                        return Text(
                          "${user['first name']} ${user['last name']}",
                          style: Theme.of(context).textTheme.headline6,
                        );
                      } else {
                        return Text('Invalid user data');
                      }
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn("16", "Friends"),
                  _buildInfoColumn("16", "Connections"),
                  _buildInfoColumn("16", "Posts"),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text("Edit Profile"),
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
                  backgroundColor: Colors.red,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .where(
                      'UserEmail',
                      isEqualTo: '${currentUser.email}', // Filter by user email
                    )
                    .orderBy(
                      "TimeStamp",
                      descending: true,
                    )
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return PostWidget(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                        );
                      },
                    );
                  }
                },
              ),
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
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 0),
        Text(
          label,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
