import 'package:bilmant2a/components/text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                //Welcome text
                const Text(
                  'Hello, Neighbor!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 10),

                //Welcome text part 2
                const Text(
                  'Check Out What Your Community is Doing!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
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
                            padding: EdgeInsets.only(left: 5.0),
                            child: MyTextField(
                                controller: emailTextController,
                                hintText: 'Email',
                                obscureText: false),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                            padding: EdgeInsets.only(left: 5.0),
                            child: MyTextField(
                                controller: passwordTextController,
                                hintText: 'Password',
                                obscureText: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                //login button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                //'Not a member' text
                const Text(
                  'Did not join the community yet?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),

                //sign in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Sign Up!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
