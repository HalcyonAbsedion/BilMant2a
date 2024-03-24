import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/user_tile.dart';
import 'chat_page.dart';

class DirectMessages extends StatelessWidget {
  DirectMessages({super.key});
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    dynamic currentlocation= userProvider.getUser.locations.last.toString();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 150,
        title: const Column(
          children: [
            Text(
              "Logo Here",
              style: TextStyle(
                color: Color.fromARGB(47, 202, 202, 202),
              ),
            ),
            Row(
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
          ],
        ),
      ),
      body: Row(
        children: [
          UserTile(text: currentlocation, onTap: () {
            
          },),
          _buildUserList(),
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
    String s = userData['firstName'] + " " + userData['lastName'];
    String email = userData["email"].toString();
    String uid = userData["uid"].toString();
    if (userData['email'] != _chatService.getCurrentUser()!.email) {
      return UserTile(
        text: s,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: email,
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
