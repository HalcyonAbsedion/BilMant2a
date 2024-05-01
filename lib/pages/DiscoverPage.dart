import 'package:bilmant2a/components/calendar.dart';
import 'package:bilmant2a/pages/GoogleMaps.dart';
import 'package:bilmant2a/providers/locationProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:provider/provider.dart';

class LiteModePage extends GoogleMapExampleAppPage {
  const LiteModePage({Key? key})
      : super(const Icon(Icons.map), 'Lite mode', key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        return _LiteModeBody(
            initialPosition: CameraPosition(
          target: LatLng(locationProvider.currentLocation.latitude,
              locationProvider.currentLocation.longitude),
          zoom: 15.0,
        ));
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
  void initState() {
    super.initState();

    if (mounted)
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(widget.initialPosition.target.latitude,
              widget.initialPosition.target.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      );
  }

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
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CalendarPage();
            }));
          },
          child: Text(
            "Events Calendar",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _addMarker() {
    if (!mounted) return;

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
