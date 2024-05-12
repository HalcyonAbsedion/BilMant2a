import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_provider.dart';

class Mant2aProvider extends ChangeNotifier {
  String _currentLocation = "";
  bool useFetchedValue = false;

  String get currentLocation => _currentLocation;

  Future<void> updateUserLocation(String userId, String newLocation) async {
    try {
      // Reference to the user document in Firestore
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);

      // Update the 'locations' field of the user document
      // Set the 'locations' field to a new array containing only the new location
      if (newLocation.isNotEmpty) {
        await userRef.set(
          {
            'locations': [
              newLocation
            ], // Set locations to a new array with only the new location
          },
          SetOptions(
              merge: true), // Merge the new location into the existing data
        );
      }
      print('Location updated successfully for user with ID: $userId');
    } catch (e) {
      print('Error updating location: $e');
      // Handle error as needed
    }
  }

  Future<void> getLocationName() async {
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
            String locationName = data['name'];
            locationNames.add(locationName);
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

    _currentLocation = locationNames.isNotEmpty ? locationNames[0] : '';
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

  Future<void> refreshMant2a(String uid) async {
    getLocationName();
    updateUserLocation(uid, _currentLocation);
    UserProvider().refreshUser();

    notifyListeners();
  }
}
