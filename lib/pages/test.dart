import 'package:bilmant2a/components/post_widget.dart';
import 'package:bilmant2a/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    PostProvider userProvider =
        Provider.of<PostProvider>(context, listen: false);
    await userProvider.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: postProvider.posts.length,
        itemBuilder: (context, index) {
          final post = postProvider.posts[index];
          return PostWidget(
            post: post,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Fetch posts
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
