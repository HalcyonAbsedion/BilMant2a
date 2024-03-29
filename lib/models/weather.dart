class Weather {
  final String areaName;
  final double temperature;
  final String mainCondition;
  Weather({
    required this.areaName,
    required this.temperature,
    required this.mainCondition,
  });
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        areaName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main']
    ); 
  }
}
