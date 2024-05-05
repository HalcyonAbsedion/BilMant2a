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
}
