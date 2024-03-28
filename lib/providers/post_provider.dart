import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bilmant2a/models/post.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _currentUserPosts = [];
  List<Post> _otherUserPosts = [];

  List<Post> get posts => _posts;
  List<Post> get currentUserPosts => _currentUserPosts;
  List<Post> get otherUserPosts => _otherUserPosts;

  PostProvider();

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

  Future<void> fetchCurrentUserFilteredPosts(List<dynamic> postIds) async {
    try {
      _currentUserPosts.clear();
      for (String postId in postIds) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('Posts')
            .doc(postId)
            .get();

        if (docSnapshot.exists) {
          Post post = Post.fromSnap(docSnapshot);
          _currentUserPosts.add(post);
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching current user posts: $e');
    }
  }

  Future<void> fetchOtherUserFilteredPosts(List<dynamic> otherPostIds) async {
    try {
      _otherUserPosts.clear();
      for (String postId in otherPostIds) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('Posts')
            .doc(postId)
            .get();

        if (docSnapshot.exists) {
          Post post = Post.fromSnap(docSnapshot);
          _otherUserPosts.add(post);
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching other user posts: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
