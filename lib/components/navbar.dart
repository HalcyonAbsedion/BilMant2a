import 'package:bilmant2a/components/top_bar.dart';
import 'package:bilmant2a/pages/account_page.dart';
import 'package:bilmant2a/pages/directMessages_page.dart';
import 'package:bilmant2a/pages/weather_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/postCreationPage.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          const TopBar(),
          WeatherPage(),
          const postCreationPage(),
          DirectMessages(),
          // Wrap Profile with Builder
          Builder(
            builder: (context) => Profile(),
          )
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? Colors.blue : Colors.white,
            ),
            label: '',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: (_page == 1) ? Colors.blue : Colors.white,
              ),
              label: '',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: (_page == 2) ? Colors.blue : Colors.white,
                size: 40,
              ),
              label: '',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              color: (_page == 3) ? Colors.blue : Colors.white,
            ),
            label: '',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (_page == 4) ? Colors.blue : Colors.white,
            ),
            label: '',
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }

//OLD NAVBAR
  // late PageController _pageController;

  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController();
  // }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  // void _onTabChange(int index) {
  //   _pageController.animateToPage(
  //     index,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.ease,
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {

  //   return Scaffold(
  //     bottomNavigationBar: Container(
  //       color: Colors.black,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
  //         child: GNav(
  //           backgroundColor: Colors.black,
  //           color: Colors.white,
  //           activeColor: Colors.lightBlue,
  //           tabBackgroundColor: Colors.grey.shade800,
  //           gap: 8,
  //           onTabChange: _onTabChange,
  //           padding: EdgeInsets.all(16),
  //           tabs: const [
  //             GButton(icon: Icons.home),
  //             GButton(icon: Icons.search),
  //             GButton(icon: Icons.add),
  //             GButton(icon: Icons.people),
  //             GButton(icon: Icons.person)
  //           ],
  //         ),
  //       ),
  //     ),
  //     body: PageView(
  //       controller: _pageController,
  //       physics: const NeverScrollableScrollPhysics(), // Disable scrolling
  //       children: [
  //         const TopBar(),
  //         Container(
  //             color: Colors.green,
  //             child: const Center(child: Text('Discover Page'))),
  //         const postCreationPage(),
  //         DirectMessages(),
  //         // Wrap Profile with Builder
  //         Builder(
  //           builder: (context) => Profile(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
