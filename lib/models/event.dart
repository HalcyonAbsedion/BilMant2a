import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  final String name;
  final String description;
  final String date;
  final double latitude;
  final double longitude;

  Event(this.name, this.description, this.date, this.latitude, this.longitude);
  Event.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        date = json['date'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Event.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        description = snapshot['description'],
        date = snapshot['date'],
        latitude = snapshot['latitude'].toDouble(),
        longitude = snapshot['longitude'].toDouble();

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'date': date,
        'latitude': latitude,
        'longitude': longitude,
      };
}

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createEvent({
    required String eventName,
    required double longitude,
    required double latitude,
    required String date,
    required String description,
  }) async {
    try {
      if (eventName.isNotEmpty &&
          longitude != 0 &&
          latitude != 0 &&
          date.isNotEmpty &&
          description.isNotEmpty) {
        // Parse the input date string to a DateTime object
        DateTime parsedDate = DateTime.parse(date);

        // Format the DateTime object to the desired format
        String formattedDate =
            DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").format(parsedDate);

        // Create the Event object with the formatted date
        Event event =
            Event(eventName, description, formattedDate, latitude, longitude);

        // Add the event to Firestore
        await _firestore.collection('events').add(event.toJson());

        return 'success';
      } else {
        return 'Please enter all the fields';
      }
    } catch (err) {
      return err.toString();
    }
  }
}
