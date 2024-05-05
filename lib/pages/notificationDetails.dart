import 'package:bilmant2a/components/post_widget.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';

class DetailsScreen extends StatelessWidget {
  final Post post;

  const DetailsScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 66, 74, 90),
        title: const Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostWidget(post: post),
            ),
            // Add more widgets to display additional details if needed
          ],
        ),
      ),
    );
  }
}
