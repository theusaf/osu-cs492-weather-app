import 'package:cs492_weather_app/models/weather_forecast.dart';
import '../../models/user_location.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  final Function getLocation;

  const WeatherScreen({super.key, required this.getLocation});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  
  List<WeatherForecast> _forecasts = [];

  void getForecast() async {
    if (widget.getLocation() != null) {

      List<WeatherForecast> forecasts = await getWeatherForecasts(widget.getLocation());

      setState(() {
        _forecasts = forecasts;
      });  
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getForecast();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [LocationWidget(widget: widget), ForecastWidget()],) );
  }
}

class ForecastWidget extends StatelessWidget {
  const ForecastWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("Forecast Widget");
  }
}

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.widget,
  });

  final WeatherScreen widget;

  @override
  Widget build(BuildContext context) {
    return Text((widget.getLocation() != null) ? "Location: ${widget.getLocation().city}, ${widget.getLocation().state}, ${widget.getLocation().zip}" : "No location dude!");
  }
}