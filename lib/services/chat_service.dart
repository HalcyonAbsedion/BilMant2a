import 'package:bilmant2a/models/message.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/storage/message_storage.dart';
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

  Future<void> sendMessage(
      String receiverID, String message, String senderName) async {
    final String currentUserID = _auth.currentUser!.uid;
    final Timestamp timeStamp = Timestamp.now();
    String chatRoomID = receiverID;
    if (receiverID.length > 10) {
      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      chatRoomID = ids.join('_');
    }

    Message newMessage = Message(
      senderName: senderName,
      senderID: currentUserID,
      message: message,
      chatRoomID: chatRoomID,
      timeStamp: timeStamp,
      received: false,
    );

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
  // Future<Stream<QuerySnapshot<Object?>>> getMessages(
  //     String userID, String otherUserID) async {
  //   String chatRoomID = userID;
  //   bool groupChat = userID.length < 10;
  //   if (!groupChat) {
  //     List<String> ids = [userID, otherUserID];
  //     ids.sort();
  //     chatRoomID = ids.join('_');
  //   }

  //   Stream<QuerySnapshot> messages = _firestore
  //       .collection("chat_rooms")
  //       .doc(chatRoomID)
  //       .collection("messages")
  //       .orderBy("timeStamp", descending: false)
  //       .snapshots();
  //   if (!groupChat) {
  //     String uid = otherUserID;
  //     markMessagesAsReceived(messages, uid, chatRoomID);
  //     deleteMessages(messages, uid);
  //     MessageStorage messageStorage = MessageStorage(
  //         chatId: chatRoomID, marker: "<<NEW_MESSAGE_ADDED_BY_PROGRAM>>");
  //     List<String> allMessages = await messageStorage.getMessages();
  //     print(allMessages.toString());
  //   }

  //   return messages;
  // }

  void markMessagesAsReceived(
      Stream<QuerySnapshot> messages, String currentUserId, String chatId) {
    MessageStorage messageStorage = MessageStorage(
        chatId: chatId, marker: "<<NEW_MESSAGE_ADDED_BY_PROGRAM>>");
    messages.listen((QuerySnapshot snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {
        DocumentReference docRef = doc.reference;
        if (currentUserId != getSenderIdFromMessage(doc)) {
          try {
            await docRef.update({'received': true});
            messageStorage.addContent(
                doc['timeStamp'].toString() + doc['message'].toString());
            await docRef.delete();
            print('Document marked as received successfully');
          } catch (e) {
            print('Error marking document as received: $e');
          }
        }
      }
    });
  }

  void deleteMessages(Stream<QuerySnapshot> messages, String currentUserId) {
    messages.listen((QuerySnapshot snapshot) async {
      for (DocumentSnapshot message in snapshot.docs) {
        if (currentUserId != getSenderIdFromMessage(message)) {
          try {
            DocumentReference docRef = message.reference;
            await docRef.delete();
            print('Message deleted successfully');
          } catch (e) {
            print('Error deleting message: $e');
          }
        }
      }
    });
  }

  String getSenderIdFromMessage(DocumentSnapshot message) {
    Map<String, dynamic> data = message.data() as Map<String, dynamic>;
    String senderId = data['senderID'];
    return senderId;
  }
}
