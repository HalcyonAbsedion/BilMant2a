import 'package:bilmant2a/components/post_widget.dart';
import 'package:bilmant2a/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';

class HomePage extends StatefulWidget {
  final String postType; // New parameter for post type
  const HomePage({Key? key, this.postType = 'explore'}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    posts = postProvider.getPosts;
    if (widget.postType != 'explore') {
      posts = posts.where((post) => post.postType == widget.postType).toList();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
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
        ),
      ),
    );
  }
}
