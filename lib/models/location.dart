import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherLocation {
  double latitude;
  double longitude;
  String city;
  String state;
  String zip;

  WeatherLocation(
      this.latitude, this.longitude, this.city, this.state, this.zip);
}

WeatherLocation _convertPlacementToWeatherLocation(
    {Placemark? placement, required double lat, required double lon}) {
  if (placement == null) {
    return WeatherLocation(0, 0, "City", "State", "00000");
  } else {
    return WeatherLocation(lat, lon, placement.locality!,
        placement.administrativeArea!, placement.postalCode!);
  }
}

Future<WeatherLocation> getLocationFromAddress({
  required String city,
  required String state,
  required String zip,
}) async {
  final List<Location> locations =
      await locationFromAddress("$city $state $zip");
  final location = locations.firstOrNull;
  return _convertPlacementToWeatherLocation(
      placement: null, lat: location!.latitude, lon: location.longitude);
}

Future<WeatherLocation> getLocationFromCoords(double lat, double lon) async {
  final placements = await placemarkFromCoordinates(lat, lon);
  final placement = placements.firstOrNull;
  return _convertPlacementToWeatherLocation(
      placement: placement, lat: lat, lon: lon);
}

Future<WeatherLocation> getLocationFromGPS() async {
  final Position position = await _determinePosition();
  final List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  final placemark = placemarks.firstOrNull;
  return _convertPlacementToWeatherLocation(
      placement: placemark, lat: position.latitude, lon: position.longitude);
}

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
