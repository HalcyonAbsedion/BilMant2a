class Event {
  final String name;
  final String description;
  final String date;

  Event(this.name, this.description, this.date);

  Event.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        date = json['date'];
}
