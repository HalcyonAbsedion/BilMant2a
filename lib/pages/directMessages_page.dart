import 'package:bilmant2a/components/areaNameSwitch.dart';
import 'package:bilmant2a/components/customSearchDelegate.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../components/areaNameSwitch.dart';

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LocationScreen(),
                  Padding(
                    padding: EdgeInsets.all(9.0),
                    child: Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: Column(
        children: [
          // Other widgets can be placed here
          // For example:
          UserTile(
            url: "",
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
                      receiverPhotoUrl: "",
                      senderID: userProvider.getUser.uid,
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
    String photoUrl = userData['photoUrl'];
    if (userData['email'] != _chatService.getCurrentUser()!.email) {
      return UserTile(
        text: receiverName,
        url: photoUrl,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  senderName: "",
                  receiverName: receiverName,
                  receiverID: uid,
                  receiverPhotoUrl: photoUrl,
                  senderID: _chatService.getCurrentUser()!.uid,
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
