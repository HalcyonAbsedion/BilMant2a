import 'dart:developer';

import 'package:bilmant2a/models/event.dart';
import 'package:bilmant2a/pages/addEventPage.dart';
import 'package:bilmant2a/pages/manage_organizations.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert'; // For JSON decoding

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  late Map<DateTime, List<Event>> _events = {};
  List<Event> _preSetEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadPreSetEvents();
  }

  void _loadPreSetEvents() async {
    try {
      log("TEST");
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('events').get();
      List<Event> events =
          querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();
      log(events.toString());
      setState(() {
        _preSetEvents = events;

        _populateEventsMap();
      });
    } catch (error) {
      print('Error loading events: $error');
      // Handle error appropriately, e.g., display error message to the user
    }
  }

  void _populateEventsMap() {
    for (Event event in _preSetEvents) {
      log(event.name);
      DateTime eventDate = DateTime.parse(event.date);
      _addEvent(eventDate, event.name, event.description);
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  void _addEvent(DateTime day, String eventName, String eventDescription) {
    log('Adding event: $eventName');
    setState(() {
      if (_events[day] != null) {
        _events[day]!
            .add(Event(eventName, eventDescription, day.toString(), 0, 0));
      } else {
        _events[day] = [
          Event(eventName, eventDescription, day.toString(), 0, 0)
        ];
      }
    });
    log("testing array ${_events.entries} ");
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        backgroundColor: const Color.fromARGB(255, 66, 74, 90),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCalendar(),
            Expanded(
              child: ListView(
                children: _getEventsForDay(_selectedDay).map((event) {
                  log(event.name);
                  return ListTile(
                    title: Text(event.name),
                    subtitle: Text(event.description),
                  );
                }).toList(),
              ),
            ),
            userProvider.getUser.isOrganization
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationAppExample(),
                        ),
                      );
                      // _addEvent(_selectedDay, "test event", "description");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Add Event',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: "en_US",
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromARGB(127, 118, 11, 189),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              date.day.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      calendarStyle: const CalendarStyle(
          todayDecoration:
              BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          markerDecoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.grey),
        weekendStyle: TextStyle(color: Colors.red),
      ),
      rowHeight: 43,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      availableGestures: AvailableGestures.all,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      focusedDay: _selectedDay,
      firstDay: DateTime.utc(2010, 10, 15),
      lastDay: DateTime.utc(2030, 3, 18),
      eventLoader: _getEventsForDay,
      onDaySelected: _onDaySelected,
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }
}
