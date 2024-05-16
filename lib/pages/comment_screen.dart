import 'dart:developer';

import 'package:bilmant2a/components/comment_card.dart';
import 'package:bilmant2a/models/post.dart';
import 'package:bilmant2a/models/user.dart';
import 'package:bilmant2a/providers/post_provider.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/notificationService.dart';
import 'package:bilmant2a/services/postUpload_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();
  showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await PostsMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      Post post = await Post.getPostById(widget.postId);
      String token = await NotificationService().getUserToken(post.uid);
      NotificationService().sendNotification(
          'Post Notification',
          '${name}  Just Commentted On Your Post: ${commentEditingController.text}',
          token,
          profilePic,
          post.uid,
          postId: widget.postId);

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    String username = "${user.firstName} ${user.lastName}";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 43, 48, 58),
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: user.photoUrl != ""
                    ? NetworkImage(user.photoUrl)
                    : AssetImage('assets/profile.jpg') as ImageProvider,
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    maxLines: null,
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as $username...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  postComment(user.uid, username, user.photoUrl);

                  Provider.of<PostProvider>(context, listen: false)
                      .refreshPost(widget.postId);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(
                          reverse: true,
                        ),
                      )
                      .fadeOut(duration: 2000.ms),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
