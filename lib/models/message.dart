import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID, chatRoomID, senderName;
  final Timestamp timeStamp;
  final bool received;
  String _message;

  Message({
    required this.senderID,
    required String message, // Remove 'final' modifier
    required this.chatRoomID,
    required this.timeStamp,
    required this.senderName,
    required this.received,
  }) : _message = message; // Initialize '_message' in the constructor

  String get message => _message; // Getter for 'message'

  set message(String value) {
    _message = value; // Setter for 'message'
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'chatRoomID': chatRoomID,
      'timeStamp': timeStamp,
      'message': _message, // Use '_message' here
      'senderName': senderName,
      'received': received,
    };
  }

  static Message fromSnap(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Message(
      senderID: data['senderID'],
      message: data['message'],
      chatRoomID: data['chatRoomID'],
      timeStamp: data['timeStamp'] as Timestamp,
      senderName: data['senderName'],
      received: data['received'] ?? false,
    );
  }
}
