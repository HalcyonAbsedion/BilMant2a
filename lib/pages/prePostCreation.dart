import 'package:bilmant2a/pages/postCreationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PrePostCreation extends StatelessWidget {
  const PrePostCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 21, 21, 22),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "CREATE YOUR POST",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
              "Let people know what you want, need, and/or willing to share! It's part of being a good neighbor.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              textAlign: TextAlign.center),
          const SizedBox(
            height: 150,
          ),
          const Text(
            "Click the button below to create a post",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          IconButton(
            iconSize: 100,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const postCreationPage(),
                ),
              );
            },
            icon: const Icon(Icons.add_circle),
            color: Colors.cyan,
          )
              .animate(
                onPlay: (controller) => controller.repeat(
                  reverse: true,
                ),
              )
              .scaleXY(
                end: 1.5,
                duration: 1500.ms,
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }
}
