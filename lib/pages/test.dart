import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

void main() {
  runApp(TestPage());
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  Color containerColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
            height: 50,
            width: 150,
            child: ElevatedButton(
                onPressed: () async {
                  await LaunchApp.openApp(
                      androidPackageName: 'com.example.augmentedrealitydemo',
                      // iosUrlScheme: 'pulsesecure://',
                      // appStoreLink:
                      //     'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                      openStore: true);

                  // Enter the package name of the App you want to open and for iOS add the URLscheme to the Info.plist file.
                  // The `openStore` argument decides whether the app redirects to PlayStore or AppStore.
                  // For testing purpose you can enter com.instagram.android
                },
                child: Container(
                    child: Center(
                  child: Text(
                    "Open",
                    textAlign: TextAlign.center,
                  ),
                ))),
          ),
        ),
      ),
    );
  }
}
