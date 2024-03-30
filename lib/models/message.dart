import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID, message, chatRoomID, senderName;
  final Timestamp timeStamp;
  final bool received;
  Message(
      {required this.senderID,
      required this.message,
      required this.chatRoomID,
      required this.timeStamp,
      required this.senderName,
      required this.received,});
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'chatRoomID': chatRoomID,
      'timeStamp': timeStamp,
      'message': message,
      'senderName': senderName,
      'received': received,
    };
  }
}
