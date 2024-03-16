import 'package:bilmant2a/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          receiverID.toString(), _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(receiverEmail)),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildUserInput(),
          ],
        ));
  }

  Widget _buildMessageList() {
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _chatService.getCurrentUser()!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight: Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Text(data["message"].toString()));
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            obscureText: false,
          ),
        ),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward))
      ],
    );
  }
}
