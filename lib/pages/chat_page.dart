import 'package:bilmant2a/components/chat_bubble.dart';
import 'package:bilmant2a/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class ChatPage extends StatelessWidget {
  final String senderName;
  final String receiverName;
  final String senderID;
  final String receiverID;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String receiverPhotoUrl;
  ChatService _chatService = ChatService();

  ChatPage(
      {Key? key,
      required this.receiverName,
      required this.receiverID,
      required this.senderID,
      required this.senderName,
      required this.receiverPhotoUrl}) {
    _chatService = ChatService(senderId: senderID, receiverId: receiverID);
    _chatService.getChatRoomKey();
  }

  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        _messageController.text,
        senderName,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Color.fromARGB(139, 255, 255, 255),
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
              radius: 25,
              backgroundImage: receiverPhotoUrl != ""
                  ? NetworkImage(receiverPhotoUrl)
                  : null,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        List<QueryDocumentSnapshot> querySnapshot = snapshot.data!.docs;
        List<Message> messages =
            querySnapshot.map((doc) => Message.fromSnap(doc)).toList();

        return FutureBuilder(
          future: _decryptMessages(messages),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Decrypting..");
            }

            List<Message> decryptedMessages = snapshot.data as List<Message>;

            List<Widget> messageWidgets = [];

            Map<DateTime, List<Message>> groupedMessages =
                _groupMessagesByDate(decryptedMessages);

            groupedMessages.forEach((date, messageList) {
              messageWidgets.add(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    // DATE
                    child: Text(
                      _formatDate(date),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );

              messageWidgets.addAll(
                messageList.map((doc) => _buildMessageItem(doc)).toList(),
              );
            });

            return ListView(
              children: messageWidgets,
            );
          },
        );
      },
    );
  }

  Future<List<Message>> _decryptMessages(List<Message> messages) async {
    List<Message> decryptedMessages = [];
    for (var message in messages) {
      // print(message.message);
      // // message.message = await _chatService.decryptMessage(message.message);
      // print(message.message);
      decryptedMessages.add(message);
    }
    return decryptedMessages;
  }

  Map<DateTime, List<Message>> _groupMessagesByDate(List<Message> messages) {
    Map<DateTime, List<Message>> groupedMessages = {};

    for (var message in messages) {
      DateTime messageDate = message.timeStamp.toDate();

      DateTime dateWithoutTime =
          DateTime(messageDate.year, messageDate.month, messageDate.day);

      if (!groupedMessages.containsKey(dateWithoutTime)) {
        groupedMessages[dateWithoutTime] = [];
      }

      groupedMessages[dateWithoutTime]!.add(message);
    }

    return groupedMessages;
  }

  Widget _buildMessageItem(Message doc) {
    bool isCurrentUser = doc.senderID == senderID;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(
        senderName: receiverName,
        message: doc.message,
        isCurrentUser: isCurrentUser,
        timeStamp: doc.timeStamp,
      ),
    );
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
                borderSide: new BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
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
              ),
            ),
          ),
        )
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    if (DateTime.now().day == dateTime.day &&
        DateTime.now().month == dateTime.month &&
        DateTime.now().year == dateTime.year) {
      return 'Today';
    } else {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
  }
}
