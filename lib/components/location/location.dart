import 'package:flutter/material.dart';
import '../../models/user_location.dart';
import 'location_text.dart';

class Location extends StatefulWidget {
  // TODO: Add a setLocation function variable which should be passed from main.dart
  // See bottom_navigation for an example
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // TODO: Get rid of city, state and zip, and store the location as an object instead
  // UserLocation _location =...
  // Be sure to update the text display to display from the object.

  String state = "";
  String city = "";
  String zip = "";

  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();

  void getLocation() async {
    UserLocation location = await getLocationFromGPS();
    // TODO: use the new setLocation function passed from main.dart to update the location.
    setState(() {
      // TODO: Update the _location object instead of state, city, zip
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
    // TODO: Same changes as getLocation()
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
        // TODO: use the UserLocation _location variable instead of city, state, zip
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
