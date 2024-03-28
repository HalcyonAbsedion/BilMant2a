import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilmant2a/components/post_widget.dart';
import 'package:bilmant2a/models/post.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';

class DisplayPosts extends StatefulWidget {
  final String postType; // New parameter for post type
  final String postUserId;
  const DisplayPosts({
    Key? key,
    this.postType = 'explore',
    this.postUserId = "",
  }) : super(key: key);

  @override
  State<DisplayPosts> createState() => _DiplayPostsState();
}

class _DiplayPostsState extends State<DisplayPosts> {
  List<Post> posts = [];
  var uid;
  bool isUserPage = false;
  bool isOtherUserPage = false;
  @override
  void initState() {
    super.initState();
    isUserPage = widget.postUserId.isNotEmpty;
    if (isUserPage) {
      isOtherUserPage = widget.postUserId != uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    uid = FirebaseAuth.instance.currentUser?.uid;
    if (isUserPage) {
      if (widget.postUserId == uid) {
        posts = postProvider.currentUserPosts;
      }
    } else {
      posts = postProvider.posts;
    }
    if (widget.postType != 'explore') {
      posts = posts.where((post) => post.postType == widget.postType).toList();
    }
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => postProvider.fetchPosts(),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                // print(posts.length);
                final post = posts[index];
                return PostWidget(
                  post: post,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
