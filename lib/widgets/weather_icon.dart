import 'package:flutter/material.dart';
import 'package:cs492_weather_app/util/strings.dart';

class WeatherIcon extends StatelessWidget {
  final String weather;

  const WeatherIcon({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final normalizedWeather = weather.toLowerCase();
    final List<String> weatherStrings = [
      "sunny",
      "clear",
      "cloudy",
      "fog",
      "thunderstorm",
      "snow",
      "rain"
    ];
    weatherStrings.sort((a, b) =>
        ((similarity(b, normalizedWeather) - similarity(a, normalizedWeather)) *
                100)
            .toInt());
    return Image.asset(
      'assets/images/weather/${weatherStrings.first}.png',
    );
  }
}
