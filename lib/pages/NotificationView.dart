import 'package:bilmant2a/components/post_widget.dart';
import 'package:bilmant2a/models/post.dart';
import 'package:bilmant2a/pages/notificationDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Screen'),
        backgroundColor: const Color.fromARGB(255, 66, 74, 90),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Notifications')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notifications = snapshot.data!.docs;
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final notification =
                  notifications[index].data() as Map<String, dynamic>;
              return notification['Title'] == "Post Notification"
                  ? GestureDetector(
                      onTap: () async {
                        // Navigate to desired screen when notification is tapped
                        Post post =
                            await Post.getPostById("${notification['postId']}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                    post: post,
                                  )),
                        );
                      },
                      child: listViewItem(notification),
                    )
                  : listViewItem(notification);
            },
          );
        },
      ),
    );
  }

  Widget listViewItem(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(notification['Icon']), // Pass icon URL
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText(notification['Title']), // Display title
                  message(notification['Body']),
                  timeAndDate(notification['datePublished']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget prefixIcon(String iconUrl) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(iconUrl), // Load image from URL
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget titleText(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget message(String body) {
    double textSize = 14;
    return Container(
      child: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: '',
          style: TextStyle(
              fontSize: textSize,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: body,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeAndDate(Timestamp datePublished) {
    // Format the date and time as needed
    final dateTime = datePublished.toDate();
    final formattedDate = dateTime.toString().split(' ')[0];
    final formattedTime = dateTime.toString().split(' ')[1].substring(0, 5);
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 10),
          ),
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
