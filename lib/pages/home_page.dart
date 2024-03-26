import 'package:bilmant2a/components/post_widget.dart';
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
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);
    await postProvider.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.cyan,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: postProvider.posts.length,
                itemBuilder: (context, index) {
                  final post = postProvider.posts[index];
                  if (post.postType == widget.postType) {
                    return PostWidget(
                      post: post,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
