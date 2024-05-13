import 'package:bilmant2a/providers/mant2a_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilmant2a/components/post_widget.dart';
import 'package:bilmant2a/models/post.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'dart:math' as Math;

class DisplayPosts extends StatefulWidget {
  final String postType; // New parameter for post type
  final String postUserId;
  const DisplayPosts({
    Key? key,
    this.postType = 'explore',
    this.postUserId = "",
  }) : super(key: key);

  @override
  State<DisplayPosts> createState() => _DiplayPostsState();
}

class _DiplayPostsState extends State<DisplayPosts> {
  List<Post> posts = [];
  var uid;
  bool isUserPage = false;
  bool isOtherUserPage = false;
  @override
  void initState() {
    super.initState();

    isUserPage = widget.postUserId.isNotEmpty;
    if (isUserPage) {
      print("user");
      isOtherUserPage = widget.postUserId != uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final Mant2aProvider mant2aProvider = Provider.of<Mant2aProvider>(context);

    uid = FirebaseAuth.instance.currentUser?.uid;
    if (isUserPage) {
      if (widget.postUserId == uid) {
        posts = postProvider.currentUserPosts;
      } else {
        posts = postProvider.otherUserPosts;
      }
    } else {
      posts = postProvider.posts;
      if (mant2aProvider.useFetchedValue) {
        posts = posts
            .where((post) => post.location == mant2aProvider.currentLocation)
            .toList();
      }

      if (widget.postType != 'explore') {
        posts =
            posts.where((post) => post.postType == widget.postType).toList();
      }
    }
    return RefreshIndicator(
      onRefresh: () => postProvider.fetchPosts(),
      child: Container(
        color: const Color.fromRGBO(24, 25, 26, 100),
        child: ListView.separated(
          physics:
              RangeMaintainingScrollPhysics(parent: BouncingScrollPhysics()),
          separatorBuilder: (context, int) => Container(
            height: 5,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostWidget(
              post: post,
            );
          },
        ),
      ),
    );
    // return DynMouseScroll(
    //   // durationMS: 800, // Set the duration of scroll events (in milliseconds)
    //   scrollSpeed: BouncingScrollSimulation
    //       .maxSpringTransferVelocity, // Set the scroll speed
    //   // animationCurve: Curves.easeOutQuart,
    //   builder: (context, controller, physics) => RefreshIndicator(
    //     onRefresh: () => postProvider.fetchPosts(),
    //     child: ListView.separated(
    //       controller: controller,
    //       physics: BouncingScrollPhysics(),
    //       separatorBuilder: (context, int) => Container(
    //         height: 5,
    //       ),
    //       itemCount: posts.length,
    //       itemBuilder: (context, index) {
    //         final post = posts[index];
    //         return PostWidget(
    //           post: post,
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}

class CustomBouncingScrollPhysics extends BouncingScrollPhysics {
  /// Create custom bouncing scroll physics.
  const CustomBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  // Customize the following methods as needed:

  /// The rate of deceleration for the fling animation in pixels per second squared.
  @override
  double get dragStartDistanceMotionThreshold => kTouchSlop;

  /// The minimum distance that a fling must travel before it is considered a fling.
  @override
  double get flingVelocityPenetrationFactor => 5.0;

  /// The rate at which the scroll position slows down during a fling animation.
  @override
  double frictionFactor(double overscrollFraction) =>
      0.52 * Math.pow(1 - overscrollFraction, 2);
}
