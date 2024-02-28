import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  bool isServiceEnabled;
  LocationPermission permission;

  isServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isServiceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission has been denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permission has been permanently denied. Permission can be modified in App > Settings.');
  }
  return await Geolocator.getCurrentPosition();
}

Future<bool> requestLocationPermission() async {
  bool isServiceEnabled;
  LocationPermission permission;

  isServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isServiceEnabled) {
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}

Future<bool> checkLocationPermissionStatus() async {
  LocationPermission permission = await Geolocator.checkPermission();
  return permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always ||
      permission == LocationPermission.denied;
}
