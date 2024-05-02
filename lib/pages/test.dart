import 'dart:convert';
import 'dart:developer';

import 'package:bilmant2a/services/notificationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String token =
      'fW1IYcdsQvi2UVRzXdPFOE:APA91bFha5VC64PXfVLHfhyJwsbceG2u3nH8sIIVK3dqcbphWpWLIrS2TgvQYYlzHykdFCtQ9DIyJdtNmIwxzXIo09cyOh8J-J1LaPTyb-t40NXZ9skjTULHyQWddV7vHLAZG8Z5wevV';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    NotificationService().requestPermission();
    NotificationService().init(context);
    super.initState();
  }

  _incrementCounter() {
    setState(() {
      _counter++;
    });
    NotificationService().sendNotification(
        'Hi ',
        'increment : $_counter',
        'dR6pamY4QEuBqQ7yDcrZUt:APA91bFQwz6QNmVKBB4llq-yXZtbw72DQwHIB0pqNCXaF06ATKsHtu20zlmQF2wRihUejMT0zVgPYBtfDVE9nZy-hsCwkPbenYZHYWWXebcKyLWqBsWrqMYzKi_XvvG2MGluBYuX8a7P',
        'https://images.unsplash.com/photo-1688607932382-f01b0987c897?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=988&q=80');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This Device Token:',
            ),
            Text(
              token,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
