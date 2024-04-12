import 'package:bilmant2a/pages/GoogleMaps.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class LiteModePage extends GoogleMapExampleAppPage {
  const LiteModePage({Key? key})
      : super(const Icon(Icons.map), 'Lite mode', key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentLocation(),
      builder: (context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while getting the location
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final currentLocation = snapshot.data!;
          final CameraPosition _kInitialPosition = CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 15.0, // Adjust the zoom level as per your requirement
          );
          return _LiteModeBody(initialPosition: _kInitialPosition);
        }
      },
    );
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

class _LiteModeBody extends StatefulWidget {
  final CameraPosition initialPosition;

  const _LiteModeBody({required this.initialPosition});

  @override
  _LiteModeBodyState createState() => _LiteModeBodyState();
}

class _LiteModeBodyState extends State<_LiteModeBody> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {}; // Set to hold the markers

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            child: GoogleMap(
              initialCameraPosition: widget.initialPosition,
              onMapCreated: (controller) {
                _controller = controller;
                _addMarker(); // Add marker when the map is created
              },
              markers: _markers,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await LaunchApp.openApp(
              androidPackageName: 'com.example.augmentedrealitydemo',
              // openStore: true,
            );
          },
          child: Text(
            "Open AR Application",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _addMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(widget.initialPosition.target.latitude,
              widget.initialPosition.target.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }
}
