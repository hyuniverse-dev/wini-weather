import 'package:realm/realm.dart';
import 'package:uuid/uuid.dart' as uuid_pkg;

import '../models/settings.dart';

class SettingsDataService {
  final Realm realm;

  SettingsDataService(this.realm);

  Future<Settings?> fetchSettings() async {
    var setting = realm.all<Settings>().lastOrNull;
    if (setting == null) {
      setting = await createDefaultSettings();
    }

    return setting;
  }

  Future<Settings> createDefaultSettings() async {
    final uid = uuid_pkg.Uuid();
    var defaultSettings = realm.write(() {
      realm.add(Settings(
        uid.v4(),
        true,
        true,
        11,
        00,
        true,
        true,
        true,
        true,
      ));
    });
    return defaultSettings;
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
