import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID, message, chatRoomID;
  final Timestamp timestamp;
  Message(
      {required this.senderID,
      required this.message,
      required this.chatRoomID,
      required this.timestamp});
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'chatRoomID': chatRoomID,
      'timestamp': timestamp,
      'message': message,
    };
  }
}
