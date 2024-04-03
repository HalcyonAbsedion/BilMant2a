import 'package:bilmant2a/components/chat_bubble.dart';
import 'package:bilmant2a/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';
import '../storage/message_storage.dart';

class ChatPage extends StatefulWidget {
  final String senderName;
  final String receiverName;
  final String receiverID;
  final String receiverPhotoUrl;

  ChatPage(
      {Key? key,
      required this.receiverName,
      required this.receiverID,
      required this.senderName,
      required this.receiverPhotoUrl})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  var senderId;
  List<Message> _displayedMessages = [];
  @override
  void dispose() {
    // _chatService.storeNewMessages(widget.receiverID, senderId);
    super.dispose();
  }

  void sendMessage() async {
    final String currentUserID = _auth.currentUser!.uid;
    final Timestamp timeStamp = Timestamp.now();
    String chatRoomID = widget.receiverID;
    if (widget.receiverID.length > 10) {
      List<String> ids = [currentUserID, widget.receiverID];
      ids.sort();
      chatRoomID = ids.join('_');
    }

    
    if (_messageController.text.isNotEmpty) {
      Message newMessage = Message(
      senderName: widget.senderName,
      senderID: currentUserID,
      message: _messageController.text,
      chatRoomID: chatRoomID,
      timeStamp: timeStamp,
      received: false,
    );
      await _chatService.sendMessage(
        newMessage,
        chatRoomID
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
                widget.receiverName,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            CircleAvatar(
              radius: 25,
              backgroundImage: widget.receiverPhotoUrl != ""
                  ? NetworkImage(widget.receiverPhotoUrl)
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
          // Expanded(
          //   child: _buildPreviousMessageList(),
          // ),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(context),
        ],
      ),
    );
  }
Widget _buildMessageList() {
  String senderId = _auth.currentUser!.uid;
  List<String> ids = [widget.receiverID, senderId];
  ids.sort();
  String chatRoomID = ids.join('_');
  MessageStorage messageStorage = MessageStorage(chatId: chatRoomID);

  final ScrollController _scrollController = ScrollController();

  return StreamBuilder<List<Message>>(
    stream: _chatService.listenForMessages(widget.receiverID, senderId),
    builder: (context, streamSnapshot) {
      if (streamSnapshot.hasError) {
        return Text("Error: ${streamSnapshot.error}");
      }
      if (streamSnapshot.connectionState == ConnectionState.waiting) {
        if (_displayedMessages.isNotEmpty) {
          // If there are already displayed messages, return them
          return _buildMessageListView(_displayedMessages, _scrollController);
        } else {
          // Otherwise, show loading widget
          return _buildLoadingWidget();
        }
      }

      List<Message> storedMessages = streamSnapshot.data ?? [];

      return FutureBuilder<List<Message>>(
        future: messageStorage.getStoredMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (_displayedMessages.isNotEmpty) {
              // If there are already displayed messages, return them
              return _buildMessageListView(_displayedMessages, _scrollController);
            } else {
              // Otherwise, show loading widget
              return _buildLoadingWidget();
            }
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          List<Message> storedMessages = snapshot.data ?? [];
          List<Message> allMessages = [...storedMessages, ...streamSnapshot.data!];

          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });

          _displayedMessages = allMessages;

          return _buildMessageListView(allMessages, _scrollController);
        },
      );
    },
  );
}


Widget _buildMessageListView(List<Message> messages, ScrollController scrollController) {
  List<Widget> messageWidgets = messages.map((message) => _buildMessageItem(message)).toList();
  return ListView(
    controller: scrollController,
    children: messageWidgets,
  );
}

Widget _buildMessageItem(Message message) {
  Map<String, dynamic> data = message.toMap();
  bool isCurrentUser = data['senderID'] == _chatService.getCurrentUser()!.uid;
  var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

  return Container(
    alignment: alignment,
    child: ChatBubble(
      senderName: widget.receiverName,
      message: data["message"],
      isCurrentUser: isCurrentUser,
      timeStamp: data["timeStamp"],
    ),
  );
}

Widget _buildLoadingWidget() {
  return Center(child: CircularProgressIndicator());
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
}
