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
          Expanded(
            child: _buildPreviousMessageList(),
          ),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(context),
        ],
      ),
    );
  }

  Widget _buildPreviousMessageList() {
    senderId = _auth.currentUser!.uid;
    List<String> ids = [widget.receiverID, senderId];
    ids.sort();
    String chatRoomID = ids.join('_');
    MessageStorage messageStorage = MessageStorage(chatId: chatRoomID);

    return FutureBuilder<List<Message>>(
      future: messageStorage.getStoredMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          List<Message> messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(messages[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildMessageList() {
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
        List<Widget> messageWidgets = [];

        Map<DateTime, List<QueryDocumentSnapshot>> groupedMessages =
            _groupMessagesByDate(messages);

        groupedMessages.forEach((date, messageList) {
          messageWidgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                //DATE
                child: Text(
                  _formatDate(date),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );

          messageWidgets.addAll(
            messageList
                .map((doc) => _buildMessageItem(Message.fromSnap(doc)))
                .toList(),
          );
        });

        return ListView(
          children: messageWidgets,
        );
      },
    );
  }

  Map<DateTime, List<QueryDocumentSnapshot>> _groupMessagesByDate(
      List<QueryDocumentSnapshot> messages) {
    Map<DateTime, List<QueryDocumentSnapshot>> groupedMessages = {};

    for (var message in messages) {
      Map<String, dynamic> data = message.data() as Map<String, dynamic>;
      DateTime messageDate = (data['timeStamp'] as Timestamp).toDate();

      DateTime dateWithoutTime =
          DateTime(messageDate.year, messageDate.month, messageDate.day);

      if (!groupedMessages.containsKey(dateWithoutTime)) {
        groupedMessages[dateWithoutTime] = [];
      }

      groupedMessages[dateWithoutTime]!.add(message);
    }

    // groupedMessages.forEach((date, messageList) {
    //   print('Date: $date');
    //   messageList.forEach((message) {
    //     print('Message: ${message.data()}');
    //   });
    // });

    return groupedMessages;
  }

  Widget _buildMessageItem(Message message) {
    Map<String, dynamic> data = message.toMap();
    bool isCurrentUser = data['senderID'] == _chatService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

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
