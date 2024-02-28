import 'package:realm/realm.dart';

import '../models/location.dart';

class LocationDataService {
  final Realm realm;

  LocationDataService(this.realm);

  void createLocation(Location location) {
    realm.write(() {
      realm.add(location);
    });
  }

  void updateLocation(Location location) {
    print('updateLocation 실행 >>>');
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

  List<Location> fetchLocations() {
    return realm.all<Location>().toList();
  }

  void removeLocationById(int id) {
    var location = realm.find<Location>(id);
    if (location != null) {
      realm.write(() => realm.delete(location));
    }
  }

  Future<Map<String, dynamic>> removeLocation(int id) async {
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

  int getNextId(int currentId) {
    var objects = realm.all<Location>();
    var sortedId = objects.map((e) => e.id).toList()..sort();
    for (var id in sortedId) {
      if (id > currentId) {
        return id;
      }
    }
    return -1;
  }

  bool tryFetchFirstLocationId(Location location) {
    final firstLocation = realm.all<Location>().firstOrNull;
    if (firstLocation == null || location == null) {
      return false;
    }
    return firstLocation.id != location.id;
  }

  Location? tryUpdateToNextLocation(Location location) {
    final List<Location> locations = realm.all<Location>().toList();
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

  Location? tryUpdateToBeforeLocation(Location location) {
    final List<Location> locations = realm.all<Location>().toList();
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

  Location? handleLocationUpdate(bool isNext, Location location) {
    return isNext
        ? tryUpdateToNextLocation(location)
        : tryUpdateToBeforeLocation(location);
  }
}
