import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Who Are We',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Icon(
                    Icons.question_mark,
                    color: Colors.white,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'We are a group of four ambitious computer science student with the thirst for knowledge.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                'We developed this app with the intention of reigniting the spark of companionship, friendship and union between individuals as it once was before the emergance of way to many online services. ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
