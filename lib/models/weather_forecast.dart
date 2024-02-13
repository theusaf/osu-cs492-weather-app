import 'dart:convert';

import './user_location.dart';
import 'package:http/http.dart' as http;

class WeatherForecast {
  // TODO #2: Based on the information you found in TODO #1
  // declare the variables that will be needed for your weather forecast object

  final String exampleVariable;

  const WeatherForecast({
    // TODO #3: Initialize variables here
    required this.exampleVariable
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        // TODO #4: map your json values (by key) to WeatherForecast variables
        // You will likely need to use the debugger to ensure you have the correct keys
        'name': String exampleVariable,

      } =>
        WeatherForecast(
          // TODO #5: cast each of the variables above to the WeatherForecast variables
          exampleVariable: exampleVariable,
        ),
      _ => throw const FormatException('Failed to load Weather Forecast.'),
    };
  }
}





Future<List<WeatherForecast>> getWeatherForecasts(UserLocation location) async {

  // casts latitude and longitude to strings with 2 fixed digits
  // for example: 123.456789 -> '123.45'
  String lat = location.latitude.toStringAsFixed(2);
  String long = location.longitude.toStringAsFixed(2);

  // send a request to the weather api to get forecast details
  String forecastUrl = "https://api.weather.gov/points/$lat,$long";
  http.Response forecastResponse = await http.get(Uri.parse(forecastUrl));
  final Map<String, dynamic> forecastJson = jsonDecode(forecastResponse.body);


  // grabs the forecasts url from the json response
  final String currentForecastsUrl = forecastJson["properties"]["forecast"];

  // send another request to the API which will return the specifics of the twice-daily forecasts
  http.Response currentForecastsResponse = await http.get(Uri.parse(currentForecastsUrl));
  final Map<String, dynamic> currentForecastsJson = jsonDecode(currentForecastsResponse.body);

  // gets the list of forecasts from the forecast request
  List<dynamic> forecastJsons = currentForecastsJson["properties"]["periods"];

  // TODO #1: Add a breakpoint below and run the debugger. 
  // Set a location and return to the weather screen.
  // Look through the forecastJsons This is what is returned by the api. 14 forecasts.
  // Look through what is returned, and write out all of the information that may be relevant
  // Consider which information will be needed to present a forecast to the user.
  
  List<WeatherForecast> forecasts = [];
  
  // TODO #6: After you complete the other todos, create a for loop
  // Loop through the forecastJsons, create a new WeatherForecast object (using the factory)
  // add the new WeatherForecast object to the forecasts array

  return forecasts;


}