import 'package:bilmant2a/components/post.dart';
import 'package:bilmant2a/pages/profile_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var file;

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
                    leading: Icon(Icons.camera),
                    title: Text("Picks a File"),
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
              // const Icon(
              //           Icons.edit,
              //           size: 25,
              //           color: Color.fromARGB(255, 255, 255, 255),)
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: getUserDetails(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        Map<String, dynamic>? user = snapshot.data!.data();
                        String? imageUrl =
                            user?['imageURL']; // Extract the image URL
                        return InkWell(
                          onTap: _selectPhoto,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl)
                                : null,
                            // Optionally, you can provide a placeholder image here
                            // Placeholder can be a default user avatar or a loading indicator
                            // backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : AssetImage('assets/default_avatar.png'),
                          ),
                        );
                      }
                    },
                  )
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
                          userEmail: post['UserEmail'],
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
