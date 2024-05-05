import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'POST!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Need a babysitter? Want to donate/volunteer? Or you just want to see what is going on in the neighborhood?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Pick and choose what you want to see! Or post your own and let the community help you out!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 150),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.explore,
                color: Colors.cyan,
                size: 50,
              ).animate().fadeIn(
                    delay: 1000.ms,
                  ),
              const Icon(Icons.volunteer_activism, color: Colors.red, size: 50)
                  .animate()
                  .fadeIn(
                    delay: 1500.ms,
                  ),
              const Icon(
                Icons.handshake,
                color: Colors.green,
                size: 50,
              ).animate().fadeIn(
                    delay: 2000.ms,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
