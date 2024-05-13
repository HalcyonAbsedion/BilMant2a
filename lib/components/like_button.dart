import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;

  LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLiked
          ? const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 0, 0, 0.612),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            )
          : null,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_outline_rounded,
          color: isLiked ? Color.fromRGBO(255, 0, 0, 0.612) : Colors.white,
        ),
      ),
    );
  }
}
