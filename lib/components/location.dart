import 'package:cs492_weather_app/models/location.dart';
import 'package:flutter/material.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {

  String state = '';
  String city = '';
  String zip = '';

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    final location = await getLocationFromGPS();

    setState(() {
      state = location.state;
      city = location.city;
      zip = location.zip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(
                  child: Text('Weather Location: $city, $state, $zip'),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 350,
                  child: Row(
                    children: [
                      WeatherTextField(label: "City"),
                      WeatherTextField(label: "State"),
                      WeatherTextField(label: "ZIP"),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherTextField extends StatelessWidget {
  final String label;

  const WeatherTextField({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
