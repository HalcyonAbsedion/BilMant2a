import 'dart:developer';

import 'package:bilmant2a/pages/onboarding_screen.dart';
import 'package:bilmant2a/pages/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../pages/forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  Future signIn() async {
    BuildContext? dialogContext;
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context; // Store the context before showing the dialog
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );
      await FirebaseMessaging.instance.getToken().then(
        (value) async {
          log(value!);
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(
            {'token': value},
          );
        },
      );
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(
            dialogContext!); // Use the stored context to dismiss the dialog
      }
    } on FirebaseAuthException catch (e) {
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(
            dialogContext!); // Use the stored context to dismiss the dialog
      }
      displayMessage(e.message.toString());
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'B',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ).animate().fadeIn(duration: 1500.ms),
                            const Icon(
                              Icons.location_pin,
                              size: 30,
                              color: Colors.cyan,
                            )
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true))
                                .moveY(
                                    duration: 500.ms,
                                    begin: 0,
                                    end: -10,
                                    curve: Curves.easeInOut),
                            const Text(
                              'l Mant2a',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ).animate().fadeIn(duration: 1500.ms),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //Welcome text
                  const Text(
                    'Hello, Neighbor!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ).animate().fadeIn(duration: 1500.ms, delay: 800.ms),
                  const SizedBox(height: 10),

                  //Welcome text part 2
                  const Text(
                    'Check Out What Your Community is Doing!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 1500.ms, delay: 1200.ms),
                  const SizedBox(height: 30),

                  //email textfield
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
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                controller: emailTextController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                obscureText: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().slideX(
                        duration: 500.ms,
                        delay: 1600.ms,
                        begin: -1.0,
                        curve: Curves.easeInOut,
                      ),

                  const SizedBox(height: 20),

                  //password textfield
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
                            Icons.lock,
                            size: 30,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                controller: passwordTextController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                obscureText: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().slideX(
                        duration: 500.ms,
                        delay: 1600.ms,
                        begin: 1.0,
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Forgot your password? No problem! '),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ForgotPasswordPage();
                            }));
                          },
                          child: const Text(
                            'Click Here!',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ).animate().shake(
                                duration: 500.ms,
                                delay: 2000.ms,
                                curve: Curves.easeInOut,
                              ),
                        ),
                      ],
                    ).animate().fadeIn(
                          duration: 500.ms,
                          delay: 1600.ms,
                        ),
                  ),
                  const SizedBox(height: 100),

                  //login button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(
                          reverse: true,
                        ), // Play the animation in a loop
                      )
                      .scaleXY(
                        end: 1.1,
                        duration: 1500.ms,
                        delay: 400.ms,
                        curve: Curves.easeInOut,
                      )
                      .shimmer(color: Colors.cyan),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //'Not a member' text
                      const Text(
                        'Did not join the community yet?  ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      //sign in button
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const OnBoardingScreen();
                        })),
                        child: const Center(
                          child: Text(
                            'Sign up!',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 2000.ms,
                      ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ));
  }
}
