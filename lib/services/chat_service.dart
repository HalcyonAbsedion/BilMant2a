import 'package:bilmant2a/models/message.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

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

  Future<void> sendMessage(String receiverID, String message,String senderName ) async {
    final String currentUserID = _auth.currentUser!.uid;
    final Timestamp timeStamp = Timestamp.now();
    String chatRoomID = receiverID;
    if (receiverID.length > 10) {
      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      chatRoomID = ids.join('_');
    }

    Message newMessage = Message(
        senderName: senderName ,
        senderID: currentUserID,
        message: message,
        chatRoomID: chatRoomID,
        timeStamp: timeStamp);

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
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }
}
