import 'package:bilmant2a/components/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final String message;
  final String userEmail;
  final String postId;
  final List<String> likes;

  const PostWidget(
      {super.key,
      required this.message,
      required this.userEmail,
      required this.postId,
      required this.likes});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser?.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser?.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser?.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(148, 204, 204, 204),
        border: Border.all(color: Colors.cyan),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userEmail,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(height: 10),
              Text(widget.message)
            ],
          ),
          Row(
            children: [
              likeComponent(),
              commentComponent(),
              shareComponent(),
            ],
          ),
        ],
      ),
    );
  }

  Widget likeComponent() {
    return Container(
      child: Row(
        children: [
          // Like button
          LikeButton(
            isLiked: isLiked,
            onTap: toggleLike,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(widget.likes.length.toString()),
        ],
      ),
    );
  }

  Widget commentComponent() {
    return Container(
      child: const Row(
        children: [
          IconButton(onPressed: null, icon: Icon(Icons.comment)),
          Text("999"),
        ],
      ),
    );
  }

  Widget shareComponent() {
    return Container(
      child: const Row(
        children: [
          IconButton(onPressed: null, icon: Icon(Icons.share)),
          Text("999"),
        ],
      ),
    );
  }
}
