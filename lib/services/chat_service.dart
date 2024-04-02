import 'package:bilmant2a/models/message.dart';
import 'package:bilmant2a/storage/message_storage.dart';
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
    bool isGroupChat = userID.length < 10;
    if (!isGroupChat) {
      List<String> ids = [userID, otherUserID];
      ids.sort();
      chatRoomID = ids.join('_');
    }
    var messages = _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timeStamp", descending: false);
    MessageStorage messageStorage = MessageStorage(chatId: chatRoomID);

    messages.snapshots().listen((QuerySnapshot snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {
        DocumentReference docRef = doc.reference;
        if (otherUserID != getSenderIdFromMessage(doc)) {
          try {
            Future<List<Message>> messagesM =
                fetchMessages(messages, chatRoomID);
            messageStorage.addMessages(messagesM);
            print("documents added to text file successfuly");
            await docRef.delete();
            print('Document deleted successfuly');
          } catch (e) {
            print('Error marking document as received: $e');
          }
        }
      }
    });
    return messages.snapshots();
  }

  Future<List<Message>> markMessagesAsReceived(
      Query<Map<String, dynamic>> messages,
      String currentUserId,
      String chatId) {
    MessageStorage messageStorage = MessageStorage(chatId: chatId);

    messages.snapshots().listen((QuerySnapshot snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {
        DocumentReference docRef = doc.reference;
        if (currentUserId != getSenderIdFromMessage(doc)) {
          try {
            Future<List<Message>> messagesM = fetchMessages(messages, chatId);
            await docRef.update({'received': true});
            await docRef.delete();
            messageStorage.addMessages(messagesM);
            print('Document deleted successfuly');
          } catch (e) {
            print('Error marking document as received: $e');
          }
        }
      }
    });

    return messageStorage.getStoredMessages();
  }

  String getSenderIdFromMessage(DocumentSnapshot message) {
    Map<String, dynamic> data = message.data() as Map<String, dynamic>;
    String senderId = data['senderID'];
    return senderId;
  }

  Future<List<Message>> fetchMessages(
      Query<Map<String, dynamic>> messages, String chatRoomId) async {
    List<Message> fetchedMessages = [];
    try {
      final QuerySnapshot querySnapshot = await messages.get();

      fetchedMessages =
          querySnapshot.docs.map((doc) => Message.fromSnap(doc)).toList();
    } catch (e) {
      print('Error fetching messages: $e');
    }
    int l = fetchedMessages.length;
    print("$l---------------------------------------------------");
    return fetchedMessages;
  }
}
