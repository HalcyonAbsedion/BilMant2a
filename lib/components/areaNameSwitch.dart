import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String defaultBilMant2a = 'Bil Mant2a';
  String fetchedBilMant2a = '';
  bool useFetchedValue = false;
  bool loading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    _fetchLocationNames();
  }

  Future<void> _fetchLocationNames() async {
    setState(() {
      loading = true; // Show loading indicator
    });

    String locationName = await getLocationName();
    if (mounted) {
      setState(() {
        fetchedBilMant2a = locationName.isNotEmpty
            ? 'Bil $locationName'
            : 'No locations found';
        loading = false; // Hide loading indicator after fetching is done
      });
    }
  }

  Future<String> getLocationName() async {
    List<String> locationNames = [];

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (_isWithinMainSquare(position.latitude, position.longitude)) {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('locations').get();

        double minDistance = 9999999999999;
        String nearestLocation = '';
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          double latitude = data['latitude'] * 1.0;
          double longitude = data['longitude'] * 1.0;
          double width = data['width'] * 1.0;
          double length = data['length'] * 1.0;
          double distance = Geolocator.distanceBetween(
              position.latitude, position.longitude, latitude, longitude);
          if (minDistance > distance) {
            minDistance = distance;
            nearestLocation = data['name'];
          }
          if (_isWithinArea(
            position.latitude,
            position.longitude,
            latitude,
            longitude,
            width,
            length,
          )) {
            setState(() {
              String locationName = data['name'];
              locationNames.add(locationName);
            });
          }
        });
        if (locationNames.isEmpty) {
          locationNames.add(nearestLocation);
        } else if (locationNames.length > 1) {
          locationNames[0] = nearestLocation;
        }
      } else {
        print("User location is outside the main square.");
      }
    } catch (e) {
      print('Error fetching location data: $e');
    }

    return locationNames.isNotEmpty ? locationNames[0] : '';
  }

  bool _isWithinArea(
      double userLatitude,
      double userLongitude,
      double locationLatitude,
      double locationLongitude,
      double width,
      double length) {
    double lengthMeters = length * 1000;
    double widthMeters = width * 1000;

    double distance = Geolocator.distanceBetween(
        userLatitude, userLongitude, locationLatitude, locationLongitude);

    return distance <= lengthMeters / 2 && distance <= widthMeters / 2;
  }

  bool _isWithinMainSquare(double latitude, double longitude) {
    // Define the bounds of the main square
    double minLatitude = 33.86728630377537;
    double maxLatitude = 33.90364270893905;
    double minLongitude = 35.46668979579287;
    double maxLongitude = 35.53668439096889;

    // Check if user's location falls within the bounds of the main square
    return latitude >= minLatitude &&
        latitude <= maxLatitude &&
        longitude >= minLongitude &&
        longitude <= maxLongitude;
  }

  @override
  Widget build(BuildContext context) {
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
              child: useFetchedValue
                  ? Text(
                      fetchedBilMant2a,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      defaultBilMant2a,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Switch(
              value: useFetchedValue,
              onChanged: (value) {
                setState(() {
                  useFetchedValue = value;
                });
              },
              activeColor: Colors.green, // Color when the switch is ON
              activeTrackColor:
                  Colors.lightGreenAccent, // Track color when the switch is ON
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
