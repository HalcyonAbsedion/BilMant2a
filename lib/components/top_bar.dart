import 'package:bilmant2a/pages/DisplayPosts.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Adjusted length to match the number of tabs
      child: Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.black,
        body: const TabBarView(
          children: [
            DisplayPosts(postType: 'explore'),
            DisplayPosts(postType: 'donations'),
            DisplayPosts(postType: 'volunteer'),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _boxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              _topBar(),
              const SizedBox(height: 5),
              _tabBar(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      color: Color.fromARGB(255, 43, 48, 58),
    );
  }

  Widget _topBar() {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'BIL MANT2A',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.speaker,
            color: Colors.white,
          ),
        ),
        Icon(
          Icons.backup,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _tabBar() {
    return TabBar(
      labelPadding: EdgeInsets.all(0),
      labelColor: Colors.lightGreen,
      indicatorColor: Colors.white,
      unselectedLabelColor: Colors.white,
      tabs: [
        Container(
          height: 70,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Tab(
            iconMargin: EdgeInsets.all(0),
            icon: Icon(Icons.explore),
            text: 'Explore',
          ),
        ),
        Container(
          height: 70,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Tab(
            iconMargin: EdgeInsets.all(0),
            icon: Icon(Icons.volunteer_activism),
            text: 'Donations',
          ),
        ),
        Container(
          height: 70,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Tab(
            iconMargin: EdgeInsets.all(0),
            icon: Icon(Icons.handshake),
            text: 'Volunteer',
          ),
        ),
      ],
    );
  }
}
