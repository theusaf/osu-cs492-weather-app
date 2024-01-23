import 'package:flutter/material.dart';
import '../models/location.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String state = "Oregon";
  String city = "Bend";
  String zip = "97702";

  void getLocation() async {
    WeatherLocation location = await getLocationFromGPS();
    setState(() {
      state = location.state;
      city = location.city;
      zip = location.zip;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Location: $city, $state, $zip"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100.0,
                child: TextField(
                    decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City',
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100.0,
                child: TextField(
                    decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'State',
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100.0,
                child: TextField(
                    decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Zip',
                )),
              ),
            )
          ],
        ),
        const Text("Button")
      ],
    );
  }
}
