import 'package:bilmant2a/pages/home_page.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Adjusted length to match the number of tabs
      child: Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.grey[300],
        body: const TabBarView(
          children: [
            HomePage(postType: 'explore'),
            HomePage(postType: 'donations'),
            HomePage(postType: 'volunteer'),
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
      color: Colors.black,
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
    return const TabBar(
      labelPadding: EdgeInsets.all(0),
      labelColor: Colors.lightGreen,
      indicatorColor: Colors.white,
      unselectedLabelColor: Colors.white,
      tabs: [
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.explore),
          text: 'Explore',
        ),
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.volunteer_activism),
          text: 'Donations',
        ),
        Tab(
          iconMargin: EdgeInsets.all(0),
          icon: Icon(Icons.handshake),
          text: 'Volunteer',
        ),
      ],
    );
  }
}
