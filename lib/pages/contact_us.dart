import 'dart:ui';

import 'package:flutter/material.dart';

class ContactUS extends StatelessWidget {
  const ContactUS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Contact Us!',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Having trouble with the app? Unsure about how to use it? Any recommendations you would like to make?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Feel free to contact us! We will be happy to assist you and hear your feedback!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Write something to us...',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MaterialButton(
                  onPressed: () {},
                  child: const Text(
                    'Send',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
