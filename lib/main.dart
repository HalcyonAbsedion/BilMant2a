import 'dart:developer';

import 'package:bilmant2a/auth/auth.dart';
import 'package:bilmant2a/firebase_options.dart';
import 'package:bilmant2a/providers/locationProvider.dart';
import 'package:bilmant2a/providers/mant2a_provider.dart';

import 'package:bilmant2a/providers/post_provider.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:bilmant2a/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgoundHandler(RemoteMessage message) async {
  log('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  log(
    (await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .requestNotificationsPermission())
        .toString(),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgoundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Mant2aProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        theme: BMtheme,
      ),
    );
  }
}
