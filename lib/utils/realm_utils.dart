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

Future<Map<String, dynamic>> removeLocation(int id) async {
  final config = Configuration.local([Location.schema]);
  var realm = Realm(config);
  final List<Location> locations = realm.all<Location>().toList();
  int currentIndex = locations.indexWhere((loc) => loc.id == id);

  realm.write(() {
    var locationToRemove = realm.query<Location>('id == $id').firstOrNull;
    if (locationToRemove != null) {
      realm.delete(locationToRemove);
      print(
          'Deleted location: ${locationToRemove.id}, ${locationToRemove.name}');
    }
  });

  return Future.value({
    "updatedLocations": realm.all<Location>().toList(),
    "currentIndex": currentIndex > 0 ? currentIndex - 1 : 0
  });
}
