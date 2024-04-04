import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bilmant2a/models/post.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _currentUserPosts = [];
  final List<Post> _otherUserPosts = [];

  List<Post> get posts => _posts;
  List<Post> get currentUserPosts => _currentUserPosts;
  List<Post> get otherUserPosts => _otherUserPosts;

  PostProvider();
  Post getPostByPostID(String postID) {
    return _posts.firstWhere((post) => post.postId == postID,
        orElse: () => Post.empty());
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

  void clearOtherUserPosts() {
    currentUserPosts.clear();
    otherUserPosts.clear();
    notifyListeners();
  }

  Future<void> fetchCurrentUserFilteredPosts(List<dynamic> postIds) async {
    _currentUserPosts = [];
    try {
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

  Future<void> fetchOtherUserFilteredPosts(String uid) async {
    List<dynamic> otherPostIds = await getPostIdsForUser(uid);
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

  Future<List<dynamic>> getPostIdsForUser(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        if (userData.containsKey("postIds") && userData["postIds"] is List) {
          return userData["postIds"];
        } else {
          print("postIds field either does not exist or is not a list.");
        }
      } else {
        print("User document with UID $uid does not exist.");
      }
    } catch (error) {
      print("Error occurred while getting postIds for user $uid: $error");
    }

    return [];
  }
}
