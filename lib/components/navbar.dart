import 'package:bilmant2a/components/top_bar.dart';
import 'package:bilmant2a/pages/DiscoverPage.dart';
import 'package:bilmant2a/pages/account_page.dart';
import 'package:bilmant2a/pages/directMessages_page.dart';
import 'package:bilmant2a/pages/test.dart';
import 'package:bilmant2a/pages/weather_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/postCreationPage.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';

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
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          Builder(
            builder: (context) => TopBar(),
          ),
          Builder(builder: (context) => LiteModePage()),
          Builder(
            builder: (context) => postCreationPage(),
          ),
          Builder(
            builder: (context) => DirectMessages(),
          ),
          // Wrap Profile with Builder
          Builder(builder: (context) {
            return Profile(
              userId: userProvider.getUser.uid,
            );
          })
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        border: Border.all(
          color: Color.fromARGB(255, 66, 74, 90),
        ),
        backgroundColor: Color.fromARGB(255, 43, 48, 58),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.home,
                color: (_page == 0) ? Colors.green : Colors.white,
              ),
            ),
            label: '',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: (_page == 1) ? Colors.yellow : Colors.white,
                ),
              ),
              label: '',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add_circle,
                  color: (_page == 2) ? Colors.deepPurple : Colors.white,
                ),
              ),
              label: '',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.people,
                color: (_page == 3) ? Colors.orange : Colors.white,
              ),
            ),
            label: '',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.person,
                color: (_page == 4) ? Colors.red : Colors.white,
              ),
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
