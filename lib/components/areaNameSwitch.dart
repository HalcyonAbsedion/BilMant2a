import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../providers/mant2a_provider.dart';
import '../providers/user_provider.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String defaultBilMant2a = 'Bil Mant2a';
  String fetchedBilMant2a = '';
  bool loading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    Mant2aProvider locationProvider =
        Provider.of<Mant2aProvider>(context, listen: false);
    await locationProvider.getLocationName();
  }

  @override
  Widget build(BuildContext context) {
    final Mant2aProvider mant2aProvider = Provider.of<Mant2aProvider>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    String _currentMant2a = mant2aProvider.currentLocation;
    return Animate(
      effects: [
        ShimmerEffect(
          duration: 1500.ms,
          delay: 1000.ms,
          color: Colors.cyan,
        ),
      ],
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 110.0, // Set a fixed width for the text
              child: mant2aProvider.useFetchedValue
                  ? Container(
                      constraints: BoxConstraints(
                        maxWidth: 200, // Set the maximum width constraint
                      ),
                      child: Text(
                        "$_currentMant2a",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1, // Limit to a single line
                        overflow: TextOverflow
                            .ellipsis, // Show ellipsis (...) when text overflows
                      ),
                    )
                  : Text(
                      "Bil Mant2a",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Switch(
              value:
                  mant2aProvider.useFetchedValue && _currentMant2a.isNotEmpty,
              onChanged: (value) {
                mant2aProvider.getLocationName();
                setState(() {
                  mant2aProvider.useFetchedValue =
                      value && _currentMant2a.isNotEmpty;
                  mant2aProvider.refreshMant2a(userProvider.getUser.uid);
                });
              },
              activeColor: Colors.white, // Color when the switch is ON
              activeTrackColor:
                  Colors.green, // Track color when the switch is ON
              inactiveThumbColor:
                  Colors.grey, // Color of the switch thumb when it is OFF
              inactiveTrackColor:
                  Colors.grey[300], // Track color when the switch is OFF
            ),
          ],
        ),
      ),
    );
  }
}
