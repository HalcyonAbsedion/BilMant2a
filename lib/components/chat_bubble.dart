import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String senderName;
  final Timestamp timeStamp;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.senderName,
    required this.timeStamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(timeStamp.toDate());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isCurrentUser
                ? Color.fromARGB(121, 51, 214, 29)
                : Color.fromARGB(144, 158, 158, 158),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(
              color: isCurrentUser ? Colors.lightGreen : Colors.white,
            ),
          ),
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(
            vertical: 2.5,
            horizontal: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCurrentUser ? "You" : senderName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                formattedTime,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
