import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isCurrentUser
              ? Color.fromARGB(125, 76, 175, 79)
              : const Color.fromARGB(144, 158, 158, 158),
          borderRadius: isCurrentUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : BorderRadius.only(
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
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
