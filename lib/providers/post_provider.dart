import 'dart:async';

import 'package:bilmant2a/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  late StreamSubscription<QuerySnapshot> _subscription;

  List<Post> get getPosts => _posts;

  PostProvider() {
    _subscription = FirebaseFirestore.instance
        .collection('Posts')
        .snapshots()
        .listen((querySnapshot) {
      _posts = querySnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

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

  Future<void> refreshPost(String postId) async {
    try {
      final DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .get();

      if (postSnapshot.exists) {
        int index = _posts.indexWhere((post) => post.postId == postId);
        if (index != -1) {
          _posts[index] = Post.fromSnap(postSnapshot);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error refreshing post: $e');
    }
  }
}
