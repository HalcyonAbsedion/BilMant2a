import 'dart:developer';

import 'package:bilmant2a/components/like_button.dart';
import 'package:bilmant2a/components/videoComponent.dart';
import 'package:bilmant2a/pages/comment_screen.dart';
import 'package:bilmant2a/providers/post_provider.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/notificationService.dart';
import 'package:bilmant2a/services/postUpload_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:photo_view/photo_view.dart';

import '../pages/account_page.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;
  int commentLen = 0;
  late TextEditingController _textController;
  late PostProvider postProvider;
  late String currentUserUid;
  bool isVolunteer = false;
  bool isDonations = false;
  bool isExplore = false;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    isLiked = widget.post.likes.contains(currentUserUid);
    isVolunteer = widget.post.postType == "volunteer";
    isDonations = widget.post.postType == "donations";
    isExplore = widget.post.postType == "explore";
    // log(isVolunteer.toString());
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.post.postId)
          .collection('comments')
          .get();
      int newCommentLen = snap.docs.length;

      if (mounted) {
        setState(() {
          commentLen = newCommentLen;
        });
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> toggleLike() async {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.post.postId);
    if (isLiked) {
      widget.post.likes.add(currentUserUid);
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUserUid])
      });

      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      String token = await NotificationService().getUserToken(widget.post.uid);
      NotificationService().sendNotification(
          'Post Notification',
          '${userProvider.getUser.firstName} ${userProvider.getUser.lastName} Just Liked Your Post',
          token,
          userProvider.getUser.photoUrl,
          widget.post.uid,
          postId: widget.post.postId);
    } else {
      widget.post.likes.remove(currentUserUid);
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUserUid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 43, 48, 58),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to another page
                    postProvider.fetchOtherUserFilteredPosts(widget.post.uid);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Profile(userId: widget.post.uid)),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage: widget.post.profImage != ""
                                  ? NetworkImage(widget.post.profImage)
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.post.username,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        isVolunteer
                            ? Icons.handshake
                            : isDonations
                                ? Icons.volunteer_activism
                                : isExplore
                                    ? Icons.explore
                                    : Icons.error,
                        color: Colors.cyan,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.post.location,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 1.0),
                    child: Text(
                      '-',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      _getTimeDifference(
                        widget.post.datePublished,
                      ), // Display time difference here
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  top: 8.0,
                ),
                child: Text(
                  widget.post.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Display media (images or videos)
          if (widget.post.mediaUrl.isNotEmpty)
            SizedBox(
              height: size.height * 0.4,
              child: ExpandableCarousel(
                options: CarouselOptions(
                  height: size.height * 0.4,
                  autoPlay: false,
                  viewportFraction: 1.0,
                  aspectRatio: 16 / 9,
                ),
                items: widget.post.mediaUrl.map((url) {
                  return _buildMediaItem(url);
                }).toList(),
              ),
            ),

          const SizedBox(
            height: 10,
          ),

          Container(
            padding:
                const EdgeInsets.only(top: 1, bottom: 1, left: 10, right: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: likeComponent(),
                ),
                shareComponent(),
                commentComponent(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget likeComponent() {
    return Row(
      children: [
        // Like button
        LikeButton(
          isLiked: isLiked,
          onTap: toggleLike,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          widget.post.likes.length.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget commentComponent(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CommentsScreen(
                  postId: widget.post.postId,
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
        Text(
          "$commentLen",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget shareComponent() {
    return const Row(
      children: [
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.share,
            color: Colors.white,
          ),
        ),
        Text(
          "999",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  String _getTimeDifference(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hr ago';
    } else {
      return '${difference.inDays} day ago';
    }
  }

  Widget _buildMediaItem(String url) {
    String ext = url.split('/').last.split('?').first.split('.').last;

    if (ext.toLowerCase() == 'mp4') {
      // Video case
      return AspectRatio(
        aspectRatio: MediaQuery.of(context).size.width *
            1.85 /
            MediaQuery.of(context).size.height *
            1,
        child: VideoPlayerPage(videoUrl: url),
      );
    } else {
      // Image case
      return AspectRatio(
        aspectRatio: MediaQuery.of(context).size.width *
            1.85 /
            MediaQuery.of(context).size.height *
            1,
        child: GestureDetector(
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(url),
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
        ),
      );
    }
  }
}
