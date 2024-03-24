import 'package:bilmant2a/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class editField extends StatefulWidget {
  final String label;
  String userValue;
  final String field;
  bool isDate;

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
                  icon: Icon(Icons.calendar_today_rounded),
                  labelText: "Birthdate",
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
                    setState(() {
                      _birthDateController.text =
                          DateFormat("dd-MM-yyyy").format(pickedate);
                      newValue = _birthDateController.text;
                    });
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
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: Text("Save")),
        ],
      ),
    );

    if (newValue.trim().length > 0) {
      await usersColl.doc(currentUser.uid).update({field: newValue.trim()});
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
      widget.userValue = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text("${widget.label}:"),
              Container(
                child: IconButton(
                  onPressed: () => edit(widget.field),
                  icon: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(widget.userValue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
