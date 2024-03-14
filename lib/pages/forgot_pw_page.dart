import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
              content: Text('Check your email for reset link!'),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text('Forgot your Password?',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: const Text(
                'Enter your email address below to reset your password. You will receive an email with a link to create a new password.',
                style: TextStyle(
                  fontSize: 20,
                )),
          ),
          const SizedBox(height: 30),
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
                        child: MyTextField(
                          controller: emailTextController,
                          hintText: 'Email',
                          obscureText: false,
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
