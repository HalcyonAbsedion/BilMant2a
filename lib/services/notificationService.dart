import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late BuildContext context;

  // initialize the service with context
  void init(BuildContext context) {
    this.context = context;
    _initInfo();
  }

  // request notification permissions
  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('provisional');
    } else {
      print("failed");
    }
  }

  // send notification via FCM
  sendNotification(String title, body, to, icon) async {
    print("test");
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAASoU1NNQ:APA91bELrh7_gMCwFQlWaitDpu_mauQhbD-o4m4FcdxB34Xd_LSjyW4-oCLou1RRTUAr8SMU1aS_P7OxUibSfM5jVUQ-cG-fgiIJQ25yW9WSbfO6jsynll1EADHJwpOIZJfsPOq0eb_t",
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            "to": to,
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "basic",
              'image': icon,
            },
            "data": <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
              'image': icon,
              "url": icon,
            }
          },
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  // handle local notification tap
  onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Scaffold(
                    body: Text('Second Screen'),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
  //  getToken() async {
  //   await FirebaseMessaging.instance.getToken().then(
  //     (value) async {
  //       log(value!);
  //       token = value;
  //       setState(() {});
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .update(
  //         {'token': value},
  //       );
  //     },
  //   );
  // }

  _initInfo() async {
    // Local Notification Setup
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSIntialize = DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSIntialize);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        log('${notificationResponse.notificationResponseType}.');

        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            log('${notificationResponse.payload}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(child: Text('Taps')),
                ),
              ),
            );
            break;
          case NotificationResponseType.selectedNotificationAction:
            print(notificationResponse);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(child: Text('Action')),
                ),
              ),
            );
            break;
        }
      },
    );

    // Firebase Message Recieving Code
    FirebaseMessaging.onMessage.listen((event) async {
      print("--------Message-----------");
      print("1 onMessage: ${event.notification!.title}/${event.data}");
      // Preparing to show notification on local device
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        event.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: event.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      final http.Response response =
          await http.get(Uri.parse(event.data['image']));

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'basic',
        'messages',
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.max,
        playSound: true,
        largeIcon: ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(response.bodyBytes)),
        actions: [
          const AndroidNotificationAction('1', 'Done',
              allowGeneratedReplies: true)
        ],
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        event.notification!.title,
        event.notification!.body,
        platformChannelSpecifics,
        payload: event.data['body'],
      );
    });
  }
}
