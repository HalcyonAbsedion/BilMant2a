// ignore_for_file: prefer_const_constructors

import 'package:bilmant2a/components/editField.dart';
import 'package:bilmant2a/pages/account_page.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:bilmant2a/models/user.dart" as model;

class ProfilePageEdit extends StatefulWidget {
  const ProfilePageEdit({Key? key}) : super(key: key);

  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final usersColl = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        //background

        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(68, 3, 136, 244),
                ),
                child: Icon(Icons.person, size: 72)),
            Text(
              currentUser.email!,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),

            //First name
            editField(
              label: "First Name",
              userValue: user.firstName,
              field: "firstName",
            ),

            //Last name
            editField(
              label: "Last Name",
              userValue: user.lastName,
              field: "lastName",
            ),

            //age
            editField(
              label: "BrithDate",
              userValue: user.birthDate,
              field: "birthDate",
            ),

            //bio
            editField(
              label: "Bio",
              userValue: user.bio,
              field: "bio",
            ),

            //gender
            editField(
              label: "gender",
              userValue: user.gender ? "Female" : "Male",
              field: "gender",
            ),

            //phone number
            editField(
              label: "Phone Number:",
              userValue: user.phoneNumber,
              field: "phoneNumber",
            ),
          ],
        ));
  }
}
