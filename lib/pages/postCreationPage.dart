import 'package:bilmant2a/models/media.dart';
import 'package:bilmant2a/pages/picker_screen.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bilmant2a/models/post.dart' as model;
import 'package:bilmant2a/models/user.dart' as model2;
import 'package:uuid/uuid.dart';

import '../components/areaNameSwitch.dart';
import '../providers/mant2a_provider.dart';
import '../providers/post_provider.dart';

class postCreationPage extends StatefulWidget {
  const postCreationPage({super.key});

  @override
  State<postCreationPage> createState() => _postCreationPageState();
}

class _postCreationPageState extends State<postCreationPage> {
  XFile? pickedFile;

  final user = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  final AuthMethods authMethods = AuthMethods();
  var uid;
  var username;
  var profileUrl;
  String selectedPostType = 'explore';
  final ImagePicker _imagePicker = ImagePicker();
  final List<Media> _selectedMedias = [];
  void _updateSelectedMedias(List<Media> entities) {
    setState(() {
      _selectedMedias.clear();
      _selectedMedias.addAll(entities);
      _selectedMedias[0].printFilePath();
    });
    _selectedMedias[0].printFilePath();
  }

  Future<void> _handleFloatingActionButton() async {
    final List<Media>? result = await Navigator.push<List<Media>>(
      // Navigate to the picker screen
      context,
      MaterialPageRoute(
        builder: (context) => PickerScreen(
            selectedMedias:
                _selectedMedias), // Pass the selected media items to the picker screen
      ),
    );
    if (result != null) {
      // Update selected media items with the result from the picker screen
      _updateSelectedMedias(result);
    }
  }

  void postSend(BuildContext context, String location, bool useLocation) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing dialog
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Sending post..."),
            ],
          ),
        );
      },
    );

    List<String> mediaUrl = [];
    for (var media in _selectedMedias) {
      String? url = await media.uploadToFirebaseStorage();
      if (url != null) {
        mediaUrl.add(url);
      }
    }

    String postId = const Uuid().v1();
    if (!useLocation) {
      location = "";
    }
    model.Post post = model.Post(
      description: textController.text.trim(),
      postType: selectedPostType,
      uid: uid,
      username: username,
      likes: [],
      postId: postId,
      datePublished: DateTime.now(),
      mediaUrl: mediaUrl,
      profImage: profileUrl,
      location: location,
    );

    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(postId)
        .set(post.toJson());

    await authMethods.addUserToList(
      elementToAdd: postId,
      fieldName: 'postIds',
      userId: uid,
    );

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.getUser.postIds.add(postId);

    setState(() {
      textController.clear();
      _selectedMedias.clear();
    });

    // Dismiss the loading dialog
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final Mant2aProvider mant2aProvider = Provider.of<Mant2aProvider>(context);
    final model2.User user = userProvider.getUser;
    final postProvider = Provider.of<PostProvider>(context);
    username = "${user.firstName} ${user.lastName}";
    uid = user.uid;
    profileUrl = user.photoUrl;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 43, 48, 58),
        title: const Text(
          "Post Page",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => {
              postSend(
                  context, user.locations.last, mant2aProvider.useFetchedValue),
              userProvider.refreshUser(),
              postProvider.fetchPosts(),
              postProvider
                  .fetchCurrentUserFilteredPosts(userProvider.getUser.postIds),
            },
            child: const Text(
              'Post',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(
                    reverse: true,
                  ),
                )
                .fadeOut(duration: 2000.ms),
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 21, 21, 22),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundImage: profileUrl != ""
                      ? NetworkImage(profileUrl)
                      : AssetImage('assets/profile.jpg') as ImageProvider,
                ),
              ),
              LocationScreen(),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 43, 48, 58),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
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
                            style: const TextStyle(color: Colors.cyan),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider()
            ],
          ),
          // GestureDetector(
          //   onTap: _selectPhoto,
          //   child: Container(
          //     width: 200,
          //     height: 200,
          //     color: Colors.grey[200],
          //     child: pickedFile == null
          //         ? Center(child: Icon(Icons.camera_alt, size: 50))
          //         : Image.file(
          //             File(pickedFile!.path),
          //             fit: BoxFit.cover,
          //           ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: TextField(
              autofocus: true,
              controller: textController,
              decoration: const InputDecoration(
                hintText: "Share with your neighbors...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          Expanded(
            // Add Expanded widget here
            child: ListView.builder(
              // Number of selected media items
              itemCount: _selectedMedias.length,
              // Apply bouncing scroll physics
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    // Apply padding to each selected media item
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  // Display selected media widget
                  child: _selectedMedias[index].widget,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleFloatingActionButton,
        child: const Icon(
          Icons.image_rounded,
          color: Colors.cyan,
        ),
      ),
    );
  }
}
