import 'package:morning_weather/models/weather.dart';
import 'package:realm/realm.dart';

part 'location.g.dart';

@RealmModel()
class _Location {
  @PrimaryKey()
  late final int id;
  late String licence;
  late String latitude;
  late String longitude;
  late String name;
  late String city;
  late String country;
}

int getLastPrimaryKey(Realm realm) {
  var objects = realm.all<Location>();
  if (objects.isEmpty) {
    return 1;
  } else {
    return objects
            .map((e) => e.id)
            .reduce((curr, next) => curr > next ? curr : next) +
        1;
  }
}