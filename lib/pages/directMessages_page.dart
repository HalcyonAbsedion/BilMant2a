import 'package:bilmant2a/services/chat_service.dart';
import 'package:flutter/material.dart';

import '../components/user_tile.dart';
import 'chat_page.dart';

class DirectMessages extends StatelessWidget {
  DirectMessages({super.key});
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Direct Messages')),
      body: _buildUserList(),
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
    String s = userData['first name'] + " " + userData['last name'];
    String email = userData["email"].toString();
    String uid = userData["uid"].toString();
    if(userData['email']!= _chatService.getCurrentUser()!.email){
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
    }
    else{
      return Container();
    }
  }
}
