import 'package:realm/realm.dart';
import 'package:uuid/uuid.dart' as uuid_pkg;

import '../models/settings.dart';

class SettingsDataService {
  final Realm realm;

  SettingsDataService(this.realm);

  Future<Settings> fetchSettings() async {
    return realm.all<Settings>().last;
  }

  void createDefaultSettings() {
    final uid = uuid_pkg.Uuid();
    realm.write(() {
      realm.add(Settings(
        uid.v4(),
        true,
        true,
        8,
        00,
        true,
        true,
        true,
        true,
      ));
    });
  }

  void updateSettings(
      {bool? isCelsius,
      bool? isNotificationOn,
      int? notificationHour,
      int? notificationMinute,
      bool? isTemperatureEnabled,
      bool? isFeelsLikeEnabled,
      bool? isSkyConditionEnabled,
      bool? isWindConditionEnabled}) {
    final settings = realm.all<Settings>().last;
    realm.write(() {
      if (isCelsius != null) settings.isCelsius = isCelsius;
      if (isNotificationOn != null)
        settings.isNotificationOn = isNotificationOn;
      if (notificationHour != null)
        settings.notificationHour = notificationHour;
      if (notificationMinute != null)
        settings.notificationMinute = notificationMinute;
      if (isTemperatureEnabled != null)
        settings.isTemperatureEnabled = isTemperatureEnabled;
      if (isFeelsLikeEnabled != null)
        settings.isFeelsLikeEnabled = isFeelsLikeEnabled;
      if (isSkyConditionEnabled != null)
        settings.isSkyConditionEnabled = isSkyConditionEnabled;
      if (isWindConditionEnabled != null)
        settings.isWindConditionEnabled = isWindConditionEnabled;
    });
  }
}
