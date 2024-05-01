import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: content(),
    );
  }
}

Widget content() {
  DateTime today = DateTime.now();
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
