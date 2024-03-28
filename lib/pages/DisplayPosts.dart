import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilmant2a/components/post_widget.dart';
import 'package:bilmant2a/models/post.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';

class DisplayPosts extends StatefulWidget {
  final String postType; // New parameter for post type
  final String userId = "";
  const DisplayPosts({Key? key, this.postType = 'explore'}) : super(key: key);

  @override
  State<DisplayPosts> createState() => _DiplayPostsState();
}

class _DiplayPostsState extends State<DisplayPosts> {
  List<Post> posts = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    if (widget.userId.isNotEmpty) {
      if (widget.userId == userProvider.getUser.uid) {
        postProvider
            .fetchCurrentUserFilteredPosts(userProvider.getUser.postIds);
        posts = postProvider.currentUserPosts;
      } else {
        // postProvider.fetchOtherUserFilteredPosts(userProvider.getOtherUser.postIds);
        // posts = postProvider.otherUserPosts;
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
