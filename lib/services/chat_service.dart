import 'package:bilmant2a/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;

    final Timestamp timestamp = Timestamp.now();
    String chatRoomID = receiverID;
    if (receiverID.length > 10) {
      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      chatRoomID = ids.join('_');
    }

    Message newMessage = Message(
        senderID: currentUserID,
        message: message,
        chatRoomID: chatRoomID,
        timestamp: timestamp);

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    String chatRoomID = userID;
    if (userID.length > 10) {
      List<String> ids = [userID, otherUserID];
      ids.sort();
      chatRoomID = ids.join('_');
    }
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
