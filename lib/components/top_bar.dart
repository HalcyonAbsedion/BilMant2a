import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Adjusted length to match the number of tabs
      child: Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.grey,
        body: const TabBarView(
          children: [
            Center(child: Text('Explore Page')),
            Center(child: Text('Donations Page')),
            Center(child: Text('Volunteer Page')),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
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
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.red,
        )
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
