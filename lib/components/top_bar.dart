import 'package:bilmant2a/pages/DisplayPosts.dart';
import 'package:bilmant2a/pages/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Adjusted length to match the number of tabs
      child: Scaffold(
        appBar: _appBar(),
        backgroundColor: Theme.of(context).colorScheme.background,
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

  Widget _topBar() {
    return Row(
      children: [
        Animate(
          effects: [
            ShimmerEffect(
              duration: 1500.ms,
              delay: 1000.ms,
              color: Colors.cyan,
            ),
          ],
          child: Expanded(
            child: const Text(
              'BIL MANT2A',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeOut(delay: 3000.ms).swap(
                  //animates text in top bar
                  duration: 1500.ms,
                  builder: (_, __) => const Text(
                    "Welcome!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 500.ms)
                      .fadeOut(delay: 3000.ms)
                      .swap(
                        duration: 1000.ms,
                        builder: (_, __) => const Text(
                          'BIL MANT2A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn(duration: 1500.ms, delay: 500.ms),
                      ),
                ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.help,
            color: Colors.white,
          ),
        ),
        const Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: WeatherPage(),
        ),
      ],
    );
  }

  Widget _tabBar() {
    return TabBar(
      labelPadding: EdgeInsets.all(1),
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
            child: Tab(
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
