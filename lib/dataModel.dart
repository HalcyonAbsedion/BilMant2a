import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDataModel extends ChangeNotifier {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _dataStream = _fetchData();

  // Getter to access the data stream
  Stream<QuerySnapshot<Map<String, dynamic>>> get dataStream => _dataStream;

  // Method to fetch data from Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchData() {
    return FirebaseFirestore.instance
        .collection("User Posts")
        .where(
          'UserEmail',
          isEqualTo: currentUser.email,
        )
        .orderBy(
          "TimeStamp",
          descending: true,
        )
        .snapshots();
  }
}
