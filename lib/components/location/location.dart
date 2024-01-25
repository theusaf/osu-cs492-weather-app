import 'package:flutter/material.dart';
import '../../models/user_location.dart';
import 'location_text.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String state = "";
  String city = "";
  String zip = "";

  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();

  void getLocation() async {
    UserLocation location = await getLocationFromGPS();
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

  void addLocationButtonPressed() async {
    UserLocation location = await getLocationFromAddress(
        cityController.text, stateController.text, zipController.text);

    setState(() {
      state = location.state;
      city = location.city;
      zip = location.zip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text((city != "") ? "Location: $city, $state, $zip" : ""),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocationText(
                labelText: "City", width: 100.0, controller: cityController),
            LocationText(
                labelText: "State", width: 100.0, controller: stateController),
            LocationText(
                labelText: "Zip", width: 100.0, controller: zipController)
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: addLocationButtonPressed,
          child: const Text('Add Location'),
        ),
      ],
    );
  }
}
