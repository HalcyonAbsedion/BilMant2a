import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../models/message.dart';

class MessageStorage {
  final String chatId;
  final String marker;
  String startMarker = "";
  String endMarker = "";
  MessageStorage({required this.chatId, required this.marker}) {
    startMarker = marker + "start";
    endMarker = marker + "end";
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$chatId.txt');
  }

  Future<String> readChat() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<File> addContent(String addedContent) async {
    final file = await _localFile;
    String content = await readChat();
    content += '\n$marker$addedContent';
    // Write the file
    return file.writeAsString(content);
  }

  Future<List<String>> getMessages() async {
    List<String> substrings = [];
    int startIndex = 0;
    try {
      final file = await _localFile;
      final content = await file.readAsString();
      
      while (true) {
        startIndex = content.indexOf(startMarker, startIndex);
        if (startIndex == -1) {
          break;
        }
        
        int endIndex = content.indexOf(endMarker, startIndex + startMarker.length);
        if (endIndex == -1) {
          break;
        }
        
        String substring = content.substring(startIndex + startMarker.length, endIndex).trim();
        substrings.add(substring);
        
        startIndex = endIndex + endMarker.length;
      }

      return substrings;
    } catch (e) {
      print("Error reading chat: $e");
      return [];
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

}
