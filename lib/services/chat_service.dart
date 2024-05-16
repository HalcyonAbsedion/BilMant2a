import 'dart:convert';
import 'dart:math';

import 'package:bilmant2a/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String senderId;
  final String receiverId;
  String key = "";
  String chatRoomId = "";
  bool isGroupChat = true;

  ChatService({this.senderId = "", this.receiverId = ""}) {
    chatRoomId = receiverId;
    if (receiverId.length > 22) {
      print("pc-------------------------------------------");
      List<String> ids = [senderId, receiverId];
      ids.sort();
      chatRoomId = ids.join('_');
      isGroupChat = false;
    }
  }
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> getChatRoomKey() async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection("chat_rooms").doc(chatRoomId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          key = (data['key'] as String?)!;
        }
      }
      return; // Chat room not found or data is null
    } catch (e) {
      print("Error getting chat room key: $e");
      return; // Error occurred
    }
  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  String generateRandomKey(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  String encryptMessage(String message) {
    return message;
  }

  Future<String> decryptMessage(String encryptedMessage) async {
    print("trying to decrypt: " + encryptedMessage);
    if (key.isEmpty) {
      await getChatRoomKey();
    }
    try {
      final keyBytes = encrypt.Key.fromUtf8(key);
      final iv = encrypt.IV.fromLength(16); // For AES, this is always 16
      final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
      final encrypted = encrypt.Encrypted.fromBase64(encryptedMessage);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      print("Error decrypting message: $e");
      return ''; // Return empty string on error
    }
  }

  // SEND MESSAGE
  Future<void> sendMessage(String message, String senderName) async {
    final chatRoomExists = await doesChatRoomExist(chatRoomId);
    String encryptedMessage = message;
    if (!chatRoomExists) {
      final randomKey = generateRandomKey(16);
      await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomId)
          .set({"key": randomKey});
    }
    if (!isGroupChat) {
      encryptedMessage = encryptMessage(message);
    }
    final Timestamp timeStamp = Timestamp.now();

    Message newMessage = Message(
      senderName: senderName,
      senderID: senderId,
      message: encryptedMessage,
      chatRoomID: chatRoomId,
      timeStamp: timeStamp,
      received: false,
    );

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Future<bool> doesChatRoomExist(String chatRoomID) async {
    final chatRoomSnapshot = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .get();
    bool exists = chatRoomSnapshot.exists;
    if (exists) {
      getChatRoomKey();
    }
    return exists;
  }

  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }
}
