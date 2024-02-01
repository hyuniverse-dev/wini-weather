import 'package:realm/realm.dart';

import '../models/location.dart';

void createLocation(Realm realm, Location location) {
  realm.write(() {
    realm.add(location);
  });
}

void updateLocation(Realm realm, Location location) {
  final firstLocation = realm.all<Location>().firstOrNull;
  final int id = firstLocation!.id;

  realm.write(() {
    firstLocation.latitude = location.latitude;
    firstLocation.longitude = location.longitude;
    firstLocation.name = location.name;
    firstLocation.city = location.city;
    firstLocation.country = location.country;
  });
}
