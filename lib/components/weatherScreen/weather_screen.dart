import "dart:math";

import "package:cs492_weather_app/models/user_location.dart";
import "package:flutter/material.dart";

class WeatherScreen extends StatelessWidget {
  final UserLocation? Function() getLocation;

  const WeatherScreen({super.key, required this.getLocation});

  @override
  Widget build(BuildContext context) {
    final r = Random();
    final score = r.nextInt(100);
    final location = getLocation();
    if (score > 90) {
      return const Text("Weather for X, Y, Z");
    }
    else if (location == null) {
      return const CircularProgressIndicator();
    } 
    else {
      return Text(
        'Weather for ${location.city}, ${location.state} ${location.zip}',
      );
    }
  }
}
