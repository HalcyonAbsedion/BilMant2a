import 'package:bilmant2a/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:bilmant2a/models/user.dart' as model;

import '../providers/post_provider.dart';

class editField extends StatefulWidget {
  final String label;
  String userValue;
  final String field;
  bool isDate;
  bool usernameChange = false;

  editField({
    Key? key,
    required this.label,
    required this.field,
    this.userValue = '',
    this.isDate = false,
  }) : super(key: key);

  @override
  State<editField> createState() => _editFieldState();
}

class _editFieldState extends State<editField> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersColl = FirebaseFirestore.instance.collection("Users");
  List postIds = [];
  Future<void> edit(String field) async {
    String newValue = "";
    final _birthDateController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit " + field),
        content: widget.isDate
            ? TextField(
                autofocus: true,
                controller: _birthDateController,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                  ),
                  labelText: "Press to insert date of birth",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                ),
                onTap: () async {
                  DateTime? pickedate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1905),
                    lastDate: DateTime.now(),
                  );

                  if (pickedate != null) {
                    setState(
                      () {
                        _birthDateController.text =
                            DateFormat("dd-MM-yyyy").format(pickedate);
                        newValue = _birthDateController.text;
                      },
                    );
                  }
                },
                readOnly: true,
              )
            : TextField(
                autofocus: true,
                onChanged: (value) {
                  newValue = value;
                },
              ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (newValue.trim().length > 0) {
      await usersColl.doc(currentUser.uid).update({field: newValue.trim()});
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
      widget.userValue = newValue;
      if (field == 'firstName' || field == 'lastName') {
        postIds = userProvider.getUser.postIds;
        PostProvider postProvider =
            Provider.of<PostProvider>(context, listen: false);
        for (var postId in postIds) {
          print(postId);
          DocumentReference postRef =
              FirebaseFirestore.instance.collection("Posts").doc(postId);
          final model.User user = userProvider.getUser;
          String username = "${user.firstName} ${user.lastName}";
          await postRef.update({'username': username});
        }
        postProvider.fetchPosts();
        postProvider
            .fetchCurrentUserFilteredPosts(userProvider.getUser.postIds);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("${widget.label}:"),
              IconButton(
                onPressed: () => edit(widget.field),
                icon: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.userValue,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
