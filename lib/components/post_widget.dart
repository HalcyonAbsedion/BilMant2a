import 'package:bilmant2a/components/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
    // isLiked = widget.post.likes.contains();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.post.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([widget.post.uid])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([widget.post.uid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    final _textController = TextEditingController();

    return 
      Container(
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
                  widget.post.username,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                Text(
                  widget.post.location,
                ),
                const SizedBox(height: 10),
                Text(widget.post.description),
              ],
            ),
            if (widget.post.mediaUrl.isNotEmpty)
              Column(
                children: widget.post.mediaUrl.map((url) {
                  return CachedNetworkImage(
                    imageUrl: url,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  );
                }).toList(),
              ),
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
          Text(widget.post.likes.length.toString()),
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
