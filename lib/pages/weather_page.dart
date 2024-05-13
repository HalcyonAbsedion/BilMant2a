import 'package:bilmant2a/services/weather_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/weather.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherServive = WeatherService('28b2e7237316cb531ace15386f39ba0b');
  Weather? _weather;
  _fetchWeather() async {
    String areaName = await _weatherServive.getCurrentArea();
    try {
      final weather = await _weatherServive.getWeather(areaName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assests/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.png';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.png';
      case 'thuderstorm':
        return 'assets/thunder.png';
      case 'clear':
        return 'assets/sunny.png';
      default:
        return 'assets/sunny.png';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (_weather == null) {
      return Icon(
        Icons.location_disabled_outlined,
        color: Colors.red,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4.0), // Add padding
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(176, 190, 197, 100),
            borderRadius: BorderRadius.circular(10.0), // Add border radius
          ),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(4.0), // Optional padding around Image
                child: Image.asset(
                  getWeatherAnimation(_weather?.mainCondition ?? ""),
                  height: 30.0,
                  width: 30.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 6.0), // Padding around Text
                child: Text(
                  '${_weather?.temperature.round()}°C',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
