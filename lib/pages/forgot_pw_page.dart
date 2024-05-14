import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailTextController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
  }

  Future passwordReset() async {
    bool error = false;
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTextController.text.trim());
    } on FirebaseAuthException catch (e) {
      error = true;
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
    if (!error) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Check your email for reset link!',
                style: TextStyle(color: Colors.black),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text('Forgot your Password?',
              style: TextStyle(
                fontSize: 27,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 40.0, right: 40.0),
            child: Text(
              'Enter your email address below to reset your password. You will receive an email with a link to create a new password.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 130,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.email,
                    size: 30,
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextField(
                          controller: emailTextController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: 'Enter your email here...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: passwordReset,
            child: Text(
              'Reset Password',
              style: TextStyle(color: Colors.white, height: 3, fontSize: 18),
            ),
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
