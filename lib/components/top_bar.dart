import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Futura',
        primarySwatch: Colors.teal,
      ),
      home: DefaultTabController(
        length: 4,
        child: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.grey,
      body: Center(
        child: TabBarView(
          children: [],
        ),
      ),
    );
  }

  PreferredSize _appBar() {
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
    return BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      color: Colors.black,
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'BIL MANT2A',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        const CircleAvatar(
          radius: 15,
          backgroundColor: Colors.red,
        )
      ],
    );
  }

  Widget _tabBar() {
    return TabBar(
      labelPadding: const EdgeInsets.all(0),
      labelColor: Colors.lightGreen,
      indicatorColor: Colors.white,
      unselectedLabelColor: Colors.white,
      tabs: const [
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
