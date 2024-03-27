import 'package:bilmant2a/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get getPosts => _posts;

  Future<void> fetchPosts() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Posts').get();

      _posts = querySnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }
}
