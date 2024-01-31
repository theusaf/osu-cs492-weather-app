import 'package:flutter/material.dart';
import '../../models/user_location.dart';
import 'location_text.dart';

class Location extends StatefulWidget {

  // The setter and getter for the active location
  final Function setLocation;
  final Function getLocation;

  // The list of locations
  // This needs to be stored in main.dart so it is maintained when toggling through windows
  final List<UserLocation> locations;

  const Location({super.key, required this.setLocation, required this.getLocation, required this.locations});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {

  // Edit mode allows user to delete stored locations
  bool _editMode = false;

  // When the edit button is pressed, the editMode flips to its opposite
  // true -> false
  // false -> true
  void toggleEditMode() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  // Controller that handle the text boxes
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();


  // When an item from the list is tapped, set the current location to whichever one was tapped
  void tapList(index) {
      widget.setLocation(widget.locations.elementAt(index));
  }


  // There are two ways to add the location
  // First, if the user enters text into the text boxes, geocoding will attempt to find it.
  void addLocationButtonPressed() async {
    UserLocation location = await getLocationFromAddress(
        cityController.text, stateController.text, zipController.text);
    updateLocation(location);
  }

  // Second, if the user taps the "Add GPS Location" button, the location is found via geolocation
  void addLocationGPSButtonPressed() async {
    UserLocation location = await getLocationFromGPS();
    updateLocation(location);
  }


  // Update location sets the current location to the passed location
  // Additionally, it adds the location only if the location isn't already in the list
  void updateLocation(UserLocation location) {
    widget.setLocation(location);
    setState(() {
      if (!widget.locations.contains(location)){
        widget.locations.add(location);
      }
    });
  }


  // Delete location removes the location from the list by index
  void deleteLocation(index) {
    setState(() {
      widget.locations.removeAt(index);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 225, child: userInput()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Saved Locations:"),
            IconButton(icon: const Icon(Icons.edit), onPressed: toggleEditMode, color: const Color.fromRGBO(18, 98, 227, 1.0),)
          ],
        ),
        Expanded(child: locationsListWidget()),
      ],
    );
  }

  ListView locationsListWidget() => ListView.builder(
    itemCount: widget.locations.length, 
    itemBuilder: (context, index) => ListTile(
      title: listItemText(index),
      onTap: () {tapList(index);}));

  Row listItemText(int index) => Row(
    children: [
      Text("${widget.locations.elementAt(index).city}, ${widget.locations.elementAt(index).state}, ${widget.locations.elementAt(index).zip}"),
      (_editMode) ? IconButton(onPressed: () {deleteLocation(index);}, icon: const Icon(Icons.delete, color: Color.fromRGBO(227, 18, 67, 1.0),)) : const SizedBox()
    ],
  );

  Column userInput() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Text((widget.getLocation() != null) ? "Location: ${widget.getLocation().city}, ${widget.getLocation().state}, ${widget.getLocation().zip}" : ""),
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
        buttons()
      ],
    );
  }

  Row buttons() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: addLocationButtonPressed,
              child: const Text('Add Location'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                      onPressed: addLocationGPSButtonPressed,
                      child: const Text('Add GPS Location'),
                    ),
          ),
        ],
      );
  }
}
