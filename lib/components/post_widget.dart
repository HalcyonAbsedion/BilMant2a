import 'package:bilmant2a/components/like_button.dart';
import 'package:bilmant2a/providers/post_provider.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;
  var postProvider;
  var currentUserUid = "";
  void initState() {
    super.initState();
    // isLiked = widget.post.likes.contains();
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    isLiked = widget.post.likes.contains(currentUserUid);
    print(currentUserUid);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.post.postId);
    if (isLiked) {
      widget.post.likes.add(currentUserUid);

      postRef.update({
        'likes': FieldValue.arrayUnion([currentUserUid])
      });
    } else {
      widget.post.likes.remove(currentUserUid);
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUserUid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    final _textController = TextEditingController();
    postProvider = Provider.of<PostProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 43, 48, 58),
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
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                          shape: BoxShape.circle),
                      child: const CircleAvatar()),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.post.username,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text(
                  widget.post.location,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.post.description,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // if (widget.post.mediaUrl.isNotEmpty)
          //   Column(
          //     children: widget.post.mediaUrl.map((url) {
          //       return CachedNetworkImage(
          //         imageUrl: url,
          //         placeholder: (context, url) => CircularProgressIndicator(),
          //         errorWidget: (context, url, error) => Icon(Icons.error),
          //       );
          //     }).toList(),
          //   ),
          Row(
            children: [
              likeComponent(),
              commentComponent(),
              shareComponent(),
            ],
          ),
          SizedBox(
            height: 50,
            child: TextField(
              controller: _textController,
              style: TextStyle(),
              decoration: InputDecoration(
                hintText: 'Comment Here...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
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
          Text(
            widget.post.likes.length.toString(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget commentComponent() {
    return Container(
      child: const Row(
        children: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.comment,
              color: Colors.white,
            ),
          ),
          Text(
            "999",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget shareComponent() {
    return Container(
      child: const Row(
        children: [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.share,
                color: Colors.white,
              )),
          Text(
            "999",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
