import 'package:realm/realm.dart';

part 'settings.g.dart';

@RealmModel()
class _Settings {
  @PrimaryKey()
  late final String uid;
  late bool isCelsius;
  late bool isNotificationOn;
  late int notificationHour;
  late int notificationMinute;
  late bool isTemperatureEnabled;
  late bool isFeelsLikeEnabled;
  late bool isSkyConditionEnabled;
  late bool isWindConditionEnabled;
}
