import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String senderName;
  final Timestamp timeStamp;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.senderName,
      required this.timeStamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isCurrentUser
              ? Color.fromARGB(121, 51, 214, 29)
              : const Color.fromARGB(144, 158, 158, 158),
          borderRadius: isCurrentUser
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          border: Border.all(
            color: isCurrentUser ? Colors.lightGreen : Colors.white,
          )),
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(
        vertical: 2.5,
        horizontal: 25,
      ),
      child: Row(
        children: [
          Text(isCurrentUser ? senderName : senderName),
          Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          Text(timeStamp.toString())
        ],
      ),
    );
  }
}
