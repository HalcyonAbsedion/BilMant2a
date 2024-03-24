import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID, message, chatRoomID, senderName;
  final Timestamp timestamp;
  Message(
      {required this.senderID,
      required this.message,
      required this.chatRoomID,
      required this.timestamp,
      required this.senderName});
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'chatRoomID': chatRoomID,
      'timestamp': timestamp,
      'message': message,
      'senderName': senderName,
    };
  }
}
