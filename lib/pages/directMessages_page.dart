import 'package:bilmant2a/components/areaNameSwitch.dart';
import 'package:bilmant2a/components/customSearchDelegate.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../components/user_tile.dart';
import '../providers/mant2a_provider.dart';
import 'chat_page.dart';

class DirectMessages extends StatelessWidget {
  DirectMessages({super.key});
  final ChatService _chatService = ChatService();
  String senderName = "";

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final Mant2aProvider mant2aProvider = Provider.of<Mant2aProvider>(context);
    senderName =
        userProvider.getUser.firstName + " " + userProvider.getUser.lastName;
    String current_location = mant2aProvider.currentLocation;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        backgroundColor: const Color.fromRGBO(24, 25, 26, 100),
        toolbarHeight: 150,
        scrolledUnderElevation: 4,
        title: Column(
          children: [
            Animate(
              effects: [
                SlideEffect(
                  duration: 500.ms,
                  delay: 500.ms,
                ),
                const FadeEffect(),
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LocationScreen(),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: Column(
        children: [
          // Other widgets can be placed here
          // For example:
          Container(
              child: mant2aProvider.useFetchedValue &&
                      current_location.isNotEmpty
                  ? UserTile(
                      url:
                          "https://i.pinimg.com/1200x/98/53/c5/9853c5ae293810fc37fb567c8940c303.jpg",
                      text: current_location,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                senderName: "",
                                receiverName: current_location,
                                receiverID: current_location,
                                receiverPhotoUrl:
                                    "https://i.pinimg.com/1200x/98/53/c5/9853c5ae293810fc37fb567c8940c303.jpg",
                                senderID: _chatService.getCurrentUser()!.uid,
                              ),
                            ));
                      },
                    )
                  : Container()),
          Expanded(
            child: _buildUserList(), // Using Expanded to take available space
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    String receiverName = userData['firstName'] + " " + userData['lastName'];
    String uid = userData["uid"].toString();
    String photoUrl = userData['photoUrl'];
    if (userData['email'] != _chatService.getCurrentUser()!.email) {
      return UserTile(
        text: receiverName,
        url: photoUrl,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  senderName: "",
                  receiverName: receiverName,
                  receiverID: uid,
                  receiverPhotoUrl: photoUrl,
                  senderID: _chatService.getCurrentUser()!.uid,
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
