import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String message;
  final String user;

  const PostWidget({
    super.key,
    required this.message,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(height: 10),
              Text(message)
            ],
          )
        ],
      ),
    );
  }
}
