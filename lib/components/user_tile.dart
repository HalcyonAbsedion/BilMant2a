import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String url;
  final void Function()? onTap;
  const UserTile(
      {super.key, required this.text, required this.onTap, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: url != "" ? NetworkImage(url) : null,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(text)
        ]),
      ),
    );
  }
}
