import 'dart:convert';
import 'dart:developer';

import 'package:bilmant2a/components/calendar.dart';
import 'package:bilmant2a/models/event.dart';
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
  List<Event> _preSetEvents = [];
  void _loadPreSetEvents() async {
    String jsonString =
        await DefaultAssetBundle.of(context).loadString('assets/events.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      _preSetEvents =
          jsonData.map((eventData) => Event.fromJson(eventData)).toList();
      _populateEventsMap();
    });
  }

  void _populateEventsMap() {
    for (Event event in _preSetEvents) {
      log(event.longitude.toString());
      DateTime eventDate = DateTime.parse(event.date);
      _addMarker(event.latitude, event.longitude);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreSetEvents();
    if (mounted)
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(widget.initialPosition.target.latitude,
              widget.initialPosition.target.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 700.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.89,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CalendarPage();
              }));
            },
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await LaunchApp.openApp(
                        androidPackageName: 'com.example.augmentedrealitydemo',
                        // openStore: true,
                      );
                    },
                    child: const Text(
                      "Open AR Application",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      "Events Calendar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.cyan,
            elevation: 4,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // Position
    );
  }

  void _addMarker(double latitude, double longitude) {
    if (!mounted) return;

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('$latitude-$longitude'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: 'Event Location'),
        ),
      );
    });
  }
}
