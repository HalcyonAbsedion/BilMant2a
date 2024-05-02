import 'package:bilmant2a/pages/about_us.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bilmant2a/pages/profile_edit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 21, 21, 22),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 43, 48, 58),
          elevation: 0,
          title: const Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Edit Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePageEdit(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.support,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Support',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Contact Us!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.help,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'About Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUs(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
