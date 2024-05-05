import 'package:bilmant2a/pages/DisplayPosts.dart';
import 'package:bilmant2a/pages/NotificationView.dart';
import 'package:bilmant2a/pages/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:badges/badges.dart' as badges;

import 'areaNameSwitch.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Adjusted length to match the number of tabs
      child: Scaffold(
        appBar: _appBar(context),
        backgroundColor: const Color.fromARGB(255, 21, 21, 22),
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

  PreferredSizeWidget _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(130),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _boxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              _topBar(context),
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
      border: Border(
        bottom: BorderSide(
          color: Color.fromARGB(255, 66, 74, 90),
        ),
      ),
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      color: Color.fromARGB(255, 43, 48, 58),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        // Leads to Error so this has been commented
        // heres the erorr
//         Exception has occurred.
// FlutterError (setState() called after dispose(): _LocationScreenState#778b8(lifecycle state: defunct, not mounted)
// This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
// The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
// This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().)
        LocationScreen(),
        const Expanded(
          child: SizedBox(
            width: 10,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: WeatherPage(),
        ),
        // badges.Badge(
        //   badgeAnimation: const badges.BadgeAnimation.slide(),
        //   badgeContent: const Text(
        //     "0",
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.notifications,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: IconButton(
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const NotificationView();
            })),
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ).animate().shake(duration: 2.seconds),
        ),
      ],
    );
  }

  Widget _tabBar() {
    return TabBar(
      labelPadding: const EdgeInsets.all(1),
      labelColor: Colors.white,
      indicatorColor: Colors.transparent,
      indicatorPadding: EdgeInsets.zero,
      indicatorWeight: double.minPositive,
      dividerHeight: 0,
      unselectedLabelColor: Colors.grey[700],
      tabs: [
        Animate(
          effects: [
            ShimmerEffect(
              duration: 1500.ms,
              delay: 1000.ms,
              color: Colors.cyan,
            )
          ],
          child: Container(
            height: 70,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Tab(
              iconMargin: EdgeInsets.all(0),
              icon: Icon(Icons.explore),
              text: 'Explore',
            ),
          ),
        ),
        Animate(
          effects: [
            ShimmerEffect(
              duration: 1500.ms,
              delay: 1500.ms,
              color: Colors.red,
            )
          ],
          child: Container(
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
        ),
        Animate(
          effects: [
            ShimmerEffect(
              duration: 1500.ms,
              delay: 2000.ms,
              color: Colors.green,
            )
          ],
          child: Container(
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
              icon: Icon(Icons.handshake),
              text: 'Volunteer',
            ),
          ),
        ),
      ],
    );
  }
}
