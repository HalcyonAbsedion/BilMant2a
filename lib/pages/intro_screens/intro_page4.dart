import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'DISCOVER!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            "Discover new places, events, and activities in your area with our very own map and augmented reality features!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            "Keep up to date with what's happening in your community with our calendar and event features!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 150,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.search,
                color: Colors.yellow,
                size: 50,
              ).animate().moveX(
                  begin: -700,
                  end: 0,
                  duration: 2000.ms,
                  delay: 500.ms,
                  curve: Curves.easeOutBack),
              const Icon(
                Icons.calendar_month,
                color: Colors.blue,
                size: 50,
              ).animate().moveX(
                  begin: 700,
                  end: 0,
                  delay: 500.ms,
                  duration: 2000.ms,
                  curve: Curves.easeOutCirc),
            ],
          ),
        ],
      ),
    );
  }
}
