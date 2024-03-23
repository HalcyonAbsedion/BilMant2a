import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}

class _MyAppState extends State<MyApp> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: content(),
    );
  }

  content() {}
}

Widget content() {
  // ignore: prefer_typing_uninitialized_variables
  var today;
  var onDaySelected;
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        Text("Up-coming event on ${today.toString().split(" ")[0]}"),
        Container(
          child: TableCalendar(
            locale: "en_US",
            rowHeight: 43,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 15),
            lastDay: DateTime.utc(2030, 3, 18),
            onDaySelected: onDaySelected,
          ),
        ),
      ],
    ),
  );
}
