import 'dart:ui';

import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 43, 48, 58),
          elevation: 0,
          title: const Text(
            "Contact Us",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 21, 21, 22),
        body: SafeArea(
          child: SingleChildScrollView(
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

                // For name
                const Text('Name'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write something to us...',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // For email
                const Text('Email'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write something to us...',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // For subject
                const Text('Subject'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write something to us...',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // For message
                const Text('Message'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write something to us...',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
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
          ),
        ));
  }
}
