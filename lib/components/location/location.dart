import 'package:cs492_weather_app/widgets/theme_builder.dart';
import 'package:flutter/material.dart';
import '../../models/user_location.dart';
import '../../models/location_database.dart';

class Location extends StatefulWidget {
  // The setter and getter for the active location
  final Function setLocation;
  final Function getLocation;
  final Function? closeEndDrawer;

  const Location({
    super.key,
    required this.setLocation,
    required this.getLocation,
    this.closeEndDrawer,
  });

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // Edit mode allows user to delete stored locations
  bool _editMode = false;
  int isLoading = 0;
  LocationDatabase? _db;

  final List<UserLocation> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  void _loadDatabase() async {
    LocationDatabase db = await LocationDatabase.open();
    List<UserLocation> locations = await db.getLocations();

    setState(() {
      _db = db;
      _setLocationsFromDatabase(locations);
    });
  }

  void _setLocationsFromDatabase(List<UserLocation> locations) async {
    _locations.addAll(locations);
  }

  void _insertLocationIntoDatabase(UserLocation location) async {
    if (_db != null) {
      _db?.insertLocation(location);
    }
  }

  void _deleteLocationFromDatabase(UserLocation location) async {
    if (_db != null) {
      _db?.deleteLocation(location);
    }
  }

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
    widget.closeEndDrawer!();
    widget.setLocation(_locations.elementAt(index));
  }

  // There are two ways to add the location
  // First, if the user enters text into the text boxes, geocoding will attempt to find it.
  void addLocationButtonPressed() async {
    setState(() {
      isLoading = 1;
    });
    UserLocation? location = await getLocationFromAddress(
        cityController.text, stateController.text, zipController.text);
    if (location != null) {
      updateLocation(location);
    } else {
      setState(() {
        isLoading = 0;
      });
    }
  }

  // Second, if the user taps the 'Add GPS Location' button, the location is found via geolocation
  void addLocationGPSButtonPressed() async {
    setState(() {
      isLoading = 2;
    });
    UserLocation location = await getLocationFromGPS();
    updateLocation(location);
  }

  // Update location sets the current location to the passed location
  // Additionally, it adds the location only if the location isn't already in the list
  void updateLocation(UserLocation location) {
    widget.setLocation(location);
    setState(() {
      isLoading = 0;
      if (!_locations.contains(location)) {
        _locations.add(location);
        _insertLocationIntoDatabase(location);
      }
    });
  }

  // Delete location removes the location from the list by index
  void deleteLocation(index) {
    setState(() {
      _deleteLocationFromDatabase(_locations.elementAt(index));
      _locations.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _locations.isNotEmpty ? savedListColumn() : userInput();
  }

  Column savedListColumn() {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: userInput(),
        ),
        savedLocation(),
        SizedBox(height: 150, child: locationsListWidget()),
      ],
    );
  }

  Widget savedLocation() {
    return ThemeBuilder(builder: (context, colorScheme, textTheme) {
      return Row(
        children: [
          Text('Saved Locations:', style: textTheme.labelLarge),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.edit),
            onPressed: toggleEditMode,
            color: colorScheme.onSurface,
          )
        ],
      );
    });
  }

  Widget locationsListWidget() =>
      ThemeBuilder(builder: (context, colorScheme, textTheme) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView.builder(
              itemCount: _locations.length,
              itemBuilder: (context, index) => ListTile(
                  title: listItemText(index),
                  onTap: () {
                    tapList(index);
                  })),
        );
      });

  Widget listItemText(int index) =>
      ThemeBuilder(builder: (context, colorScheme, textTheme) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200,
              child: Text(
                '${_locations.elementAt(index).city}, ${_locations.elementAt(index).state}, ${_locations.elementAt(index).zip}',
              ),
            ),
            if (_editMode)
              IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: 30,
                  onPressed: () {
                    deleteLocation(index);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: colorScheme.error,
                  ))
          ],
        );
      });

  Widget userInput() {
    return ThemeBuilder(builder: (context, colorScheme, textTheme) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocationText(labelText: 'City', controller: cityController),
              Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: LocationText(
                          labelText: 'State', controller: stateController)),
                  LocationText(
                      labelText: 'Zip', width: 100.0, controller: zipController)
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: addLocationButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add Manual Location', style: textTheme.labelMedium),
                if (isLoading == 1)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                            color: colorScheme.onSurface),
                      ),
                    ],
                  )
              ],
            ),
          ),
          ElevatedButton(
            onPressed: addLocationGPSButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add Current Location', style: textTheme.labelMedium),
                const Icon(Icons.location_on_outlined),
                if (isLoading == 2)
                  SizedBox(
                    width: 10,
                    height: 10,
                    child:
                        CircularProgressIndicator(color: colorScheme.onSurface),
                  )
              ],
            ),
          ),
        ],
      );
    });
  }
}

class LocationText extends StatefulWidget {
  const LocationText(
      {super.key,
      required this.labelText,
      this.width,
      required this.controller});

  final String labelText;
  final double? width;
  final TextEditingController controller;

  @override
  State<LocationText> createState() => _LocationTextState();
}

class _LocationTextState extends State<LocationText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: widget.width,
        child: TextField(
            controller: widget.controller,
            style: const TextStyle(fontSize: 15.0, height: 1.0),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.labelText,
            )),
      ),
    );
  }
}
