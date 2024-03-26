import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String postType;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final List<String> mediaUrl;
  final String profImage;
  final String location;

  const Post({
    required this.description,
    required this.postType,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.mediaUrl,
    required this.profImage,
    required this.location,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot["description"],
      postType: snapshot["postType"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      datePublished: (snapshot["datePublished"] as Timestamp).toDate(),
      username: snapshot["username"],
      mediaUrl: (snapshot['mediaUrl'] as List<dynamic>)
          .map((url) => url.toString())
          .toList(),
      profImage: snapshot['profImage'],
      location: snapshot['location'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "postType": postType,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'mediaUrl': mediaUrl,
        'profImage': profImage,
        'location': location,
      };
}
