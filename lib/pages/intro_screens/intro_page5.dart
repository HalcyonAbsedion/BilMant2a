import 'package:flutter/material.dart';

class IntroPage5 extends StatelessWidget {
  const IntroPage5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Column(
        children: [
          SizedBox(height: 40),
          Text(
            'AND SO MUCH MORE!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 250),
          Text(
            'SIGN UP AND DISCOVER ALL THE AMAZING FEATURES BIL MANT2A HAS TO OFFER!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
