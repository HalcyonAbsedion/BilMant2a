import 'package:bilmant2a/components/chat_bubble.dart';
import 'package:bilmant2a/components/text_field.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final String senderName;
  final String receiverName;
  final String receiverID;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatPage({super.key, required this.receiverName, required this.receiverID, required this.senderName});

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          receiverID.toString(), _messageController.text, senderName);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 24, 24, 24),
        appBar: AppBar(
          shape: Border(
            bottom: BorderSide(
              color: const Color.fromARGB(139, 255, 255, 255),
              width: 1,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  receiverName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
              ),
            ],
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildUserInput(context),
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
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child:
            ChatBubble(senderName: data["senderName"] ,message: data["message"], isCurrentUser: isCurrentUser));
            
  }

  Widget _buildUserInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Type a message...',
              focusedBorder: OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.cyan, width: 1),
                borderRadius: new BorderRadius.circular(25.7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: new BorderRadius.circular(25.7),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue,
            ),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                )),
          ),
        )
      ],
    );
  }
}
