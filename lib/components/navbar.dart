import 'package:bilmant2a/components/top_bar.dart';
import 'package:bilmant2a/pages/account_page.dart';
import 'package:bilmant2a/pages/directMessages_page.dart';
import 'package:bilmant2a/pages/home_page.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../pages/postCreationPage.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChange(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.lightBlue,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            onTabChange: _onTabChange,
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(icon: Icons.home),
              GButton(icon: Icons.search),
              GButton(icon: Icons.add),
              GButton(icon: Icons.people),
              GButton(icon: Icons.person)
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        children: [
          const TopBar(),
          Container(
              color: Colors.green,
              child: const Center(child: Text('Discover Page'))),
          const postCreationPage(),
          DirectMessages(),
          // Wrap Profile with Builder
          Builder(
            builder: (context) => Profile(),
          ),
        ],
      ),
    );
  }
}
