import 'package:geolocator/geolocator.dart';

import 'package:geocoding/geocoding.dart';

// User location model
// Contains required information for:
// Displaying location to user (city, state, zip)
// Finding Forecast information in Weather API (latitude, Longitude)

const allowedNation = "United States";

class UserLocation {
  double latitude;
  double longitude;
  String city;
  String state;
  String zip;

  UserLocation(this.latitude, this.longitude, this.city, this.state, this.zip);
}

Future<UserLocation> getLocationFromAddress(
    String city, String state, String zip) async {
  // async function that delivers a UserLocation using the city, state, and/or zip

  String addressString = "$city $state $zip";

  // geocoding can potentially return locations with only partial addresses
  List<Location> locations = await locationFromAddress(addressString);

  return getLocationFromCoords(locations[0].latitude, locations[0].longitude);
}

Future<UserLocation> getLocationFromGPS() async {
  // async function that delivers a UserLocation using phone's GPS Coordinates

  Position position = await _determinePosition();

  return getLocationFromCoords(position.latitude, position.longitude);
}

Future<UserLocation> getLocationFromCoords(
    double latitude, double longitude) async {
  // async function that delivers a UserLocation using latitude and longitude

  String city = "";
  String state = "";
  String zip = "";
  String country = "";

  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

  // State: administrativeArea
  // City: locality
  // Zip: postalCode
  // Country: country

  // Loops through the locations attempting to find a city, state, and zip in the address information
  for (int i = 0; i < placemarks.length; i++) {
    if (city == "") {
      city = placemarks[i].locality!;
    }
    if (state == "") {
      state = placemarks[i].administrativeArea!;
    }
    if (zip == "") {
      zip = placemarks[i].postalCode!;
    }
    if (country == "") {
      country = placemarks[i].country!;
    }
  }

  if (country != allowedNation) {
    Future.error("Error: Location must be in $allowedNation.");
  }

  return UserLocation(latitude, longitude, city, state, zip);
}

// NOTE: THIS FUNCTION IS A HELPER FUNCTION DIRECTLY FROM THE GEOLOCATOR DOCUMENTATION.
// SEE: https://pub.dev/packages/geolocator

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
