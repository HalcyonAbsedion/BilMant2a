import 'package:bilmant2a/components/post_widget.dart';
import 'package:bilmant2a/models/post.dart';
import 'package:bilmant2a/pages/DisplayPosts.dart';
import 'package:bilmant2a/pages/profile_edit.dart';
import 'package:bilmant2a/pages/settings_page.dart';
import 'package:bilmant2a/providers/post_provider.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/notificationService.dart';
import 'package:bilmant2a/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:provider/provider.dart';
import 'package:bilmant2a/services/auth_service.dart';

class Profile extends StatefulWidget {
  final String userId;
  const Profile({super.key, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthMethods _authMethods = AuthMethods();
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchData();
  }

  Future<void> fetchData() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    postProvider.clearOtherUserPosts();
    postProvider.fetchCurrentUserFilteredPosts(userProvider.getUser.postIds);
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      postLen = userSnap.data()!['postIds'].length;

      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      userData = userSnap.data()!;
      setState(() {});
    } catch (error) {
      print("Error fetching user data: $error");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    String currentUserUid = userProvider.getUser.uid;
    bool isCurrentUser = currentUserUid == widget.userId;

    if (isCurrentUser) {
      followers = userProvider.getUser.followers.length;
      following = userProvider.getUser.following.length;
      postLen = userProvider.getUser.postIds.length;
      isLoading = false;
    } else {}
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 43, 48, 58),
              elevation: 0,
              actions: [
                const SizedBox(
                  width: 300,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                      );
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 21, 21, 22),
            body: Column(
              children: [
                Animate(
                  effects: [
                    ShimmerEffect(color: Colors.cyan, duration: 1000.ms),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      isCurrentUser
                          ? "${userProvider.getUser.firstName} ${userProvider.getUser.lastName}"
                          : "${userData['firstName']} ${userData?['lastName'] ?? ""}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 10,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: isCurrentUser
                                ? (userProvider.getUser.photoUrl != ""
                                    ? NetworkImage(
                                        userProvider.getUser.photoUrl)
                                    : null)
                                : (userData?['photoUrl'] != null
                                    ? NetworkImage(userData?['photoUrl'])
                                    : null),
                          ),
                        ),
                      ),
                    ).animate().fadeIn().slideX(
                          delay: 1000.ms,
                          begin: 1.5,
                          duration: 1500.ms,
                          curve: Curves.easeInOutBack,
                        ),
                    const SizedBox(
                      width: 15,
                    ),
                    _buildInfoColumn(
                      "$followers",
                      "Followers",
                    ).animate().fadeIn(delay: 2000.ms),
                    const SizedBox(
                      width: 15,
                    ),
                    _buildInfoColumn(
                      "$following",
                      "Following",
                    ).animate().fadeIn(delay: 2000.ms),
                    const SizedBox(
                      width: 15,
                    ),
                    _buildInfoColumn(
                      "$postLen",
                      "Posts",
                    ).animate().fadeIn(delay: 2000.ms),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        isCurrentUser
                            ? "${userProvider.getUser.bio} "
                            : "${userData['bio'] ?? ""} ",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white),
                      ).animate().fadeIn(
                            delay: 2000.ms,
                          ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [],
                      ),
                      const SizedBox(height: 10),
                      Center(
                          child: isCurrentUser
                              ? ElevatedButton(
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePageEdit(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    fixedSize: const Size(225, 50),
                                    backgroundColor: Colors.grey[300],
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  child: Text(
                                    isFollowing ? "Unfollow" : "Follow",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    try {
                                      // Toggle follow status
                                      await FirebaseMethods().followUser(
                                          currentUserUid, userData?['uid']);

                                      // Update UI based on follow status
                                      setState(() {
                                        if (isFollowing) {
                                          isFollowing = false;
                                          followers--;
                                        } else {
                                          isFollowing = true;
                                          followers++;
                                          NotificationService().sendNotification(
                                              'BilMant2a',
                                              '${userProvider.getUser.firstName} ${userProvider.getUser.lastName} Just Followed',
                                              '${userData['token']}',
                                              'https://images.unsplash.com/photo-1688607932382-f01b0987c897?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=988&q=80');
                                        }
                                        userProvider.refreshUser();
                                      });
                                    } catch (error) {
                                      print(
                                          "Error toggling follow status: $error");
                                      // Handle error if necessary
                                    }
                                  },
                                  //edit button
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    fixedSize: const Size(300, 50),
                                    backgroundColor: Colors.grey[300],
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                      const SizedBox(height: 10),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: DisplayPosts(postUserId: widget.userId),
                ),
              ],
            ),
          );
  }

  Widget _buildInfoColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 0),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
