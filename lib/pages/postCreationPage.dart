import 'package:bilmant2a/models/media.dart';
import 'package:bilmant2a/pages/picker_screen.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bilmant2a/models/post.dart' as model;
import 'package:bilmant2a/models/user.dart' as model2;
import 'package:uuid/uuid.dart';

class postCreationPage extends StatefulWidget {
  const postCreationPage({super.key});

  @override
  State<postCreationPage> createState() => _postCreationPageState();
}

class _postCreationPageState extends State<postCreationPage> {
  XFile? pickedFile;

  final user = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
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
                    },
                  )
                ],
              ),
              onClosing: () {},
            ));
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

  void postSend(String location) async {
    List<String> mediaUrl = [];
    for (var media in _selectedMedias) {
      String? url = await media.uploadToFirebaseStorage();
      if (url != null) {
        mediaUrl.add(url);
      }
    }
    String postId = const Uuid().v1();
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
        location: location);
    FirebaseFirestore.instance
        .collection("Posts")
        .doc(postId)
        .set(post.toJson());
    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model2.User user = Provider.of<UserProvider>(context).getUser;
    username = "${user.firstName} ${user.lastName}";
    uid = user.uid;
    profileUrl = user.photoUrl;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Post to"),
        actions: [
          TextButton(
            onPressed: () => postSend(user.locations.last),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage:
                    profileUrl != "" ? NetworkImage(profileUrl) : null,
              ),
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
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
        // Call _handleFloatingActionButton method when FloatingActionButton is pressed
        onPressed: _handleFloatingActionButton,
        // Floating action button icon
        child: const Icon(Icons.image_rounded),
      ),
    );
  }
}
