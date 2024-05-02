import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 43, 48, 58),
        elevation: 0,
        title: const Text(
          "About Us",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Who Are We',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const Icon(
                    Icons.question_mark,
                    color: Colors.white,
                    size: 30,
                  ).animate().shake(
                        duration: 3000.ms,
                      ),
                ],
              ).animate().fadeIn(
                    duration: 500.ms,
                  ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 1000.ms,
                      ),
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 1900.ms,
                      ),
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 1600.ms,
                      ),
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 1300.ms,
                      ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'We are a group of four ambitious computer science student with the thirst for knowledge.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ).animate().fadeIn(
                    duration: 500.ms,
                    delay: 2000.ms,
                  ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                'We developed this app with the intention of reigniting the spark of companionship, friendship and union between individuals as it once was before the emergance of way to many online services. ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ).animate().fadeIn(
                    duration: 500.ms,
                    delay: 2500.ms,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
