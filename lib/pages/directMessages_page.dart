import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../components/user_tile.dart';
import 'chat_page.dart';

class DirectMessages extends StatelessWidget {
  DirectMessages({super.key});
  final ChatService _chatService = ChatService();
  String senderName = "";

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    senderName =
        userProvider.getUser.firstName + " " + userProvider.getUser.lastName;
    dynamic currentlocation = userProvider.getUser.locations.last.toString();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 150,
        title: Column(
          children: [
            Animate(
              effects: [
                SlideEffect(
                  duration: 500.ms,
                  delay: 500.ms,
                ),
                const FadeEffect(),
              ],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Direct Messages',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton.filled(
              onPressed: () {},
              icon: Icon(Icons.location_pin),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
      body: Column(
        children: [
          // Other widgets can be placed here
          // For example:
          UserTile(
            text: currentlocation,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      senderName: userProvider.getUser.firstName +
                          " " +
                          userProvider.getUser.lastName,
                      receiverName: currentlocation,
                      receiverID: currentlocation.toString().toLowerCase(),
                    ),
                  ));
            },
          ),
          Expanded(
            child: _buildUserList(), // Using Expanded to take available space
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    String receiverName = userData['firstName'] + " " + userData['lastName'];
    String uid = userData["uid"].toString();
    if (userData['email'] != _chatService.getCurrentUser()!.email) {
      return UserTile(
        text: receiverName,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  senderName: "",
                  receiverName: receiverName,
                  receiverID: uid,
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
