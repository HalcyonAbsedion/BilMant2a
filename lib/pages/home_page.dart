import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('signed in as ' + user.email!),
            // MaterialButton(onPressed: () {
            //   FirebaseAuth.instance.signOut();
            // },child: Text('Sign Out'),
            // color: Colors.red,
            // )
            IconButton(onPressed: (){
              FirebaseAuth.instance.signOut();
            }, icon: const Icon(
                              Icons.logout,
                              size: 30,
                            ))
          ],
        ),
      ),
    );
  }
}
