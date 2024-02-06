import 'package:geolocator/geolocator.dart';
import 'package:realm/realm.dart';

import '../models/location.dart';

/// 이 함수는 사용자 위치 조회 권한을 검사한 결과를 현재 위치 또는 에러 메세지로 반환합니다.
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

/// 이 함수는 사용자 위치 조회 권한 요청 결과를 boolean으로 반환합니다.
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

/// 이 함수는 현재 지역이 데이터베이스의 첫번째 지역인지 검사한 결과를 boolean으로 반환합니다.
bool tryFetchFirstLocationId(Realm realm, Location location) {
  final firstLocation = realm!.all<Location>().firstOrNull;
  if (firstLocation == null || location == null) {
    return false;
  }
  return firstLocation.id != location.id;
}

/// 이 함수는 [realm]과 [location]을 매개변수로 받아 다음 인덱스에 해당하는 지역 데이터를 반환합니다.
Location? tryUpdateToNextLocation(Realm realm, Location location) {
  final List<Location> locations = realm!.all<Location>().toList();
  final currentIndex = locations.indexWhere((loc) => loc.id == location.id);
  Location currentLocation = locations[currentIndex];
  if (currentIndex != -1 && currentIndex < locations.length - 1) {
    var nextLocation = locations[currentIndex + 1];
    if (location.id != nextLocation.id) {
      return nextLocation;
    }
  }
  return null;
}

/// 이 함수는 [realm]과 [location]을 매개변수로 받아 이전 인덱스에 해당하는 지역 데이터를 반환합니다.
Location? tryUpdateToBeforeLocation(Realm realm, Location location) {
  final List<Location> locations = realm!.all<Location>().toList();
  int currentIndex = locations.indexWhere((loc) => loc.id == location.id);
  Location currentLocation = locations[currentIndex];
  if (currentIndex != -1 && currentIndex > 0) {
    var beforeLocation = locations[currentIndex - 1];
    if (location.id != beforeLocation.id) {
      return beforeLocation;
    }
  }
  return null;
}

/// 이 함수는 사용자 위치 조회 권한 확인한 결과를 boolean으로 반환합니다.
Future<bool> checkLocationPermissionStatus() async {
  LocationPermission permission = await Geolocator.checkPermission();
  return permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always ||
      permission == LocationPermission.denied;
}

Location? handleLocationUpdate(bool isNext, Realm realm, Location location) {
  return isNext
      ? tryUpdateToNextLocation(realm, location)
      : tryUpdateToBeforeLocation(realm, location);
}