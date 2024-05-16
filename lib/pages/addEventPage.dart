import 'dart:async';

import 'package:bilmant2a/models/event.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:intl/intl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

class LocationAppExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LocationAppExampleState();
}

class _LocationAppExampleState extends State<LocationAppExample> {
  ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);
  final _eventName = new TextEditingController();
  final _description = new TextEditingController();
  var _longitude = 0.0;
  var _latitude = 0.0;
  var _dateController = new TextEditingController();
  bool _isLoading = false;
  void _displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _createEvent() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Get values from controllers
      String EventName = _eventName.text.trim();
      String date = _dateController.text.trim();
      String description = _description.text.trim();

      // Validate fields
      if (date.isEmpty || EventName.isEmpty || description.isEmpty) {
        _displayMessage("Please fill in all fields");
        return;
      }

      // Call AuthService to create user and Event
      String result = await EventService().createEvent(
          eventName: EventName,
          longitude: _longitude,
          latitude: _latitude,
          date: date,
          description: description);

      if (result == "success") {
        _displayMessage("Event created successfully!");
        // Clear text fields on success
        _eventName.clear();
        _description.clear();
        _dateController.clear();

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => NavBar(),
        //   ),
        // );
      } else {
        _displayMessage("Failed to create event: $result");
      }
    } catch (e) {
      _displayMessage("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Create Event",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _eventName,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _description,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border:
                      OutlineInputBorder(), // Adds a border around the input field
                  hintText: 'Enter your description here', // Placeholder text
                ),
              ),
              const SizedBox(height: 30),
              // ValueListenableBuilder<GeoPoint?>(
              //   valueListenable: notifier,
              //   builder: (ctx, p, child) {
              //     return AlertDialog(
              //       title: Text('Success'),
              //       content:
              //           Text('Location added successfully ${p.toString()}'),
              //       actions: <Widget>[
              //         TextButton(
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //           child: Text('OK'),
              //         ),
              //       ],
              //     );
              //   },
              // ),
              ElevatedButton(
                style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () async {
                  var p = await showSimplePickerLocation(
                    context: context,
                    isDismissible: true,
                    title: "location picker",
                    textConfirmPicker: "pick",
                    zoomOption: ZoomOption(
                      initZoom: 8,
                    ),
                    initPosition: GeoPoint(
                      latitude: 33.888820961412264,
                      longitude: 35.490306960140636,
                    ),
                    radius: 8.0,
                  );
                  if (p != null) {
                    _latitude = p.latitude;
                    _longitude = p.longitude;
                    notifier.value = p;
                  }
                },
                child: Text(
                  "Pick Location",
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: _isLoading ? null : _createEvent,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
