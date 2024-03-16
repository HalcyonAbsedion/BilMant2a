import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID, senderEmail, receiverId, message;
  final Timestamp timestamp;
  Message(
      {required this.senderID,
      required this.senderEmail,
      required this.message,
      required this.receiverId,
      required this.timestamp});
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverId,
      'timestamp': timestamp,
      'message': message,
    };
  }
}
