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

  Color getTextColor(Color backgroundColor) {
    // Calculate the relative luminance (brightness) of the background color
    final luminance = (0.2126 * backgroundColor.red +
            0.7152 * backgroundColor.green +
            0.0722 * backgroundColor.blue) /
        255.0;

    // Choose white or black text color based on contrast ratio
    return luminance > 0.5 ? Colors.black : Colors.white;
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
        return 'assets/cloudy (2).png';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.png';
      case 'thuderstorm':
        return 'assets/rainy.png';
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
      // Container(

      //   decoration: BoxDecoration(

      //     color: const Color.fromRGBO(176, 190, 197, 1.0),
      //     borderRadius: BorderRadius.circular(15.0), // Add border radius
      //   ),
      return Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                getWeatherAnimation(_weather?.mainCondition ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 15.0,
                ),
                child: Text(
                  '${_weather?.temperature.round()}°C',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
