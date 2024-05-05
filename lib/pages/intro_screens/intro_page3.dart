import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'CHAT!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Need to ask a question? Want to know more about a post? Or just want to chat with your neighbors?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Use the chat feature to connect with your neighbors and community!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 140,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.green,
                )
                    .animate()
                    .fadeIn(
                      delay: 3000.ms,
                    )
                    .moveY(delay: 3000.ms, begin: 10, end: -10)
                    .fadeOut(
                      delay: 3500.ms,
                      duration: 100.ms,
                    ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.cyan, size: 50)
                      .animate()
                      .fadeIn(
                        delay: 1000.ms,
                      ),
                  const Icon(Icons.send, color: Colors.cyan, size: 30)
                      .animate()
                      .fadeIn(
                        delay: 2000.ms,
                      )
                      .moveX(
                        begin: 0,
                        end: 300,
                        curve: Curves.easeInOut,
                        delay: 2000.ms,
                        duration: 1000.ms,
                      )
                      .fadeOut(
                        delay: 2500.ms,
                        duration: 1000.ms,
                      ),
                ],
              ),
              const Icon(Icons.person, color: Colors.cyan, size: 50)
                  .animate()
                  .fadeIn(
                    delay: 1500.ms,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
