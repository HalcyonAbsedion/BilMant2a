import 'package:bilmant2a/components/navbar.dart';
import 'package:bilmant2a/pages/login_page.dart';
import 'package:bilmant2a/providers/locationProvider.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
  }

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
    PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);
    await postProvider.fetchPosts();
    LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                addData();
                return Builder(
                  builder: (context) => NavBar(),
                );
              } else {
                return const LoginPage();
              }
            }));
  }
}
