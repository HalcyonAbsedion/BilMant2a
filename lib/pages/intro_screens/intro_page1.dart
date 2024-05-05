import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to  ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              Text(
                "Bil Mant2a!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ).animate().shimmer(duration: 1000.ms, color: Colors.cyan),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'The app that connects you to your community/neighborhood!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ).animate().fadeIn(
                delay: 1000.ms,
              ),
          const SizedBox(height: 90),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
                    "Before we sign you up, let us show you what this app is all about!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    )).animate().fadeIn(
                  delay: 1500.ms,
                ),
          ),
          const SizedBox(height: 150),
          const Icon(Icons.arrow_right_alt_rounded,
                  color: Colors.white, size: 50)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .fadeIn(delay: 1700.ms)
              .moveX(
                  begin: 0,
                  end: 100,
                  curve: Curves.easeInOutCubic,
                  duration: 1.seconds),
        ],
      ),
    );
  }
}
