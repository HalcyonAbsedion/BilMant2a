import 'package:bilmant2a/pages/chat_page.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  final ChatService _chatService = ChatService();

  CustomSearchDelegate();

  List<Map<String, dynamic>> _getUserDataListFromSnapshot(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return [];
    }
    if (snapshot.hasError) {
      return [];
    }
    return snapshot.data ?? [];
  }

  List<String> _getUserNames(List<Map<String, dynamic>> userDataList) {
    return userDataList
        .map<String>(
            (userData) => '${userData['firstName']} ${userData['lastName']}')
        .toList();
  }

  List<String> _getFilteredUserNames(List<String> userNames, String query) {
    return userNames
        .where(
            (userName) => userName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        final userDataList = _getUserDataListFromSnapshot(snapshot);
        final userNames = _getUserNames(userDataList);
        final filteredUserNames = _getFilteredUserNames(userNames, query);

        if (filteredUserNames.isEmpty) {
          return Center(
            child: Text(
              'No results found for "$query"',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredUserNames.length,
          itemBuilder: (context, index) {
            final userName = filteredUserNames[index];
            final userData = userDataList.firstWhere((userData) =>
                '${userData['firstName']} ${userData['lastName']}' == userName);
            final uid = userData['uid'];
            final photoUrl = userData['photoUrl'];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: photoUrl != ""
                    ? NetworkImage(photoUrl)
                    : AssetImage('assets/profile.jpg') as ImageProvider,
              ),
              title: Text(userName),
              onTap: () {
                _navigateToChatPage(
                    context, userName, uid, userProvider.getUser.uid, photoUrl);
              },
            );
          },
        );
      },
    );
  }

  void _navigateToChatPage(BuildContext context, String userName,
      String receiverId, String senderId, String photoUrl) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          senderName: '',
          receiverName: userName,
          receiverID: receiverId,
          receiverPhotoUrl: photoUrl,
          senderID: senderId,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
}
