import 'package:realm/realm.dart';

import '../models/location.dart';
import '../utils/location_permission_utils.dart';
import 'location_api_service.dart';
import 'location_data_service.dart';

Future<bool> refreshLocationPermissionStatus() async {
  var isAllow = await checkLocationPermissionStatus();

  final config = Configuration.local([Location.schema]);
  final realm = Realm(config);
  Location location;

  print('refreshLocationPermissionStatus 실행전 >>> ');
  if (isAllow) {
    print('refreshLocationPermissionStatus 실행 >>> ');
    var position = await determinePosition();
    final latitude = position.latitude;
    final longitude = position.longitude;
    final coordinate = '$latitude,$longitude';
    final locationData = await fetchLocationData(coordinate);
    location = Location(
      1,
      locationData.licence,
      locationData.latitude,
      locationData.longitude,
      locationData.nameDetails.officialNameEn ?? locationData.address.city!,
      locationData.address.city ?? locationData.name,
      locationData.address.country,
    );
    print('isAllow');
  } else {
    final locationData = await fetchLocationData('38.8950368,-77.0365427');
    location = Location(
      1,
      locationData.licence,
      locationData.latitude,
      locationData.longitude,
      locationData.nameDetails.officialNameEn ?? locationData.address.city!,
      locationData.address.city ?? locationData.name,
      locationData.address.country,
    );
    print('!isAllow');
  }
  LocationDataService locationDataService = LocationDataService(realm);
  locationDataService.updateLocation(location);
  return isAllow;
}
