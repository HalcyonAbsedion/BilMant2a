// ignore_for_file: prefer_const_constructors

import 'package:bilmant2a/pages/account_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfilePageEdit extends StatefulWidget {
  const ProfilePageEdit({Key? key}) : super(key: key);

  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final usersColl = FirebaseFirestore.instance.collection("Users");

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit " + field),
        content: TextField(
          autofocus: true,
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: Text("Save")),
        ],
      ),
    );

    if (newValue.trim().length > 0) {
      await usersColl.doc(currentUser.email).update({field: newValue.trim()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      //background

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                SizedBox(
                  height: 50,
                ),
                Icon(Icons.person, size: 72),
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),

                //First name
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("First Name:"),
                          IconButton(
                              onPressed: () => editField("first name"),
                              icon: Icon(Icons.settings))
                        ],
                      ),
                      Text(userData['first name']),
                    ],
                  ),
                ),
                //Last name
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Last Name:"),
                          IconButton(
                              onPressed: () => editField("last name"),
                              icon: Icon(Icons.settings))
                        ],
                      ),
                      Text(userData['last name']),
                    ],
                  ),
                ),
                //age
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Age:"),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.settings))
                        ],
                      ),
                      Text('${userData['age'].toString()}'),
                    ],
                  ),
                ),

                //bio
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Bio:"),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.settings))
                        ],
                      ),
                      Text("sdfasdf"),
                    ],
                  ),
                ),

                //location
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Location:"),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.settings))
                        ],
                      ),
                      Text("lorem"),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
