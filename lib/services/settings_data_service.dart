import 'package:realm/realm.dart';

import '../models/settings.dart';

Future<Settings> fetchSettings() async {
  var config = Configuration.local([Settings.schema]);
  var realm = Realm(config);
  var settings = realm.all<Settings>().last;
  return settings;
}
