import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import '../models/message.dart';

class MessageStorage {
  final String chatId;
  MessageStorage({required this.chatId});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final file = File('$path/$chatId.txt');

    // Check if the file exists
    if (!(await file.exists())) {
      // If the file doesn't exist, create it
      await file.create(recursive: true);
    }

    return file;
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<File> addMessages(Future<List<Message>> messages) async {
    final file = await _localFile;
    String content = await readFile();

    List<Message> messageList = await messages;

    for (Message message in messageList) {
      String escapedMessage = message.message.replaceAll('\n', '\\n');
      content +=
          '${message.senderID},${escapedMessage},${message.chatRoomID},${message.timeStamp},${message.senderName},${message.received}\n';
    }
    return file.writeAsString(content);
  }

  Future<File> addMessage(Message message) async {
    final file = await _localFile;
    String content = await readFile();
    String escapedMessage = message.message.replaceAll('\n', '\\n');
    content +=
          '${message.senderID},${escapedMessage},${message.chatRoomID},${message.timeStamp},${message.senderName},${message.received}\n';
    return file.writeAsString(content);
  }

  Future<List<Message>> getStoredMessages() async {
  final file = await _localFile;
  final content = await file.readAsString();
  List<Message> messages = [];
  try {
    List<String> lines = content.split('\n');
    for (String line in lines) {
      List<String> parts = line.split(',');
      if (parts.length == 7) {
        Message message = Message(
          senderID: parts[0],
          message: parts[1],
          chatRoomID: parts[2],
          timeStamp: parseTimestamp(parts[3]+parts[4]),
          senderName: parts[4],
          received: parts[6] == 'true',
        );
        messages.add(message);
      }
    }
    return messages;
  } catch (e) {
    print('Error reading messages: $e');
    return messages;
  }
}


  Future<void> deleteFile() async {
    try {
      final file = await _localFile;
      await file.delete();
    } catch (e) {
      print("Error deleting file: $e");
    }
  }
  Timestamp parseTimestamp(String timestampString) {
  RegExp regExp = RegExp(r'seconds=(\d+) nanoseconds=(\d+)');
  Match? match = regExp.firstMatch(timestampString);
  if (match != null) {
    int seconds = int.parse(match.group(1)!);
    int nanoseconds = int.parse(match.group(2)!);
    return Timestamp(seconds, nanoseconds);
  } else {
    throw FormatException('Invalid timestamp format');
  }
}
}
