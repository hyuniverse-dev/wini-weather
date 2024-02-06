import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:morning_weather/services/location_service.dart';
import 'package:morning_weather/utils/geo_utils.dart';
import 'package:morning_weather/utils/realm_utils.dart';
import 'package:morning_weather/widgets/settings_screen/switch_tile.dart';
import 'package:realm/realm.dart';
import 'package:uuid/uuid.dart' as uuid_pkg;
import 'package:app_settings/app_settings.dart';

import '../models/location.dart';
import '../models/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  var config = Configuration.local([Settings.schema]);
  var uid = uuid_pkg.Uuid();
  late Realm realm;
  late var settings;
  late bool isCelsius;
  late bool isNotificationOn;
  late int notificationHour;
  late int notificationMinute;
  late bool isTemperatureEnabled;
  late bool isFeelsLikeEnabled;
  late bool isSkyConditionEnabled;
  late bool isWindConditionEnabled;
  late bool isLocated;
  late TimeOfDay notificationTime =
      TimeOfDay(hour: notificationHour, minute: notificationMinute);

  @override
  void initState() {
    super.initState();
    _initSettings();
    WidgetsBinding.instance.addObserver(this);
  }

  void _initSettings() async {
    bool located = await requestLocationPermission();
    var config = Configuration.local([Settings.schema]);
    realm = Realm(config);
    settings = realm.all<Settings>().lastOrNull;
    if (settings != null) {
      setState(() {
        isLocated = located;
        isCelsius = settings.isCelsius;
        isNotificationOn = settings.isNotificationOn;
        notificationHour = settings.notificationHour;
        notificationMinute = settings.notificationMinute;
        isTemperatureEnabled = settings.isTemperatureEnabled;
        isFeelsLikeEnabled = settings.isFeelsLikeEnabled;
        isSkyConditionEnabled = settings.isSkyConditionEnabled;
        isWindConditionEnabled = settings.isWindConditionEnabled;
        notificationTime =
            TimeOfDay(hour: notificationHour, minute: notificationMinute);
      });
    } else {
      realm.write(() {
        realm.add(
            Settings(uid.v4(), true, true, 9, 00, false, false, false, false));
      });
      setState(() {
        isLocated = located;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print(state);
      refreshLocationPermissionStatus();
    }
  }

  void refreshLocationPermissionStatus() async {
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

    setState(() {
      isLocated = isAllow;
    });

    updateLocation(realm, location);
    print(isLocated);
  }

  Widget customSwitchTile(
      String title, bool isEnabled, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      value: isEnabled,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const ListTile(
              title: Text(
                'Temperature Display',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            CustomSwitchTile(
              title: '°C',
              value: isCelsius,
              onChanged: (value) => setState(
                () {
                  isCelsius = value;
                  realm.write(() {
                    settings.isCelsius = value;
                  });
                },
              ),
            ),
            CustomSwitchTile(
              title: '°F',
              value: !isCelsius,
              onChanged: (value) => setState(
                () {
                  isCelsius = !value;
                  realm.write(() {
                    settings.isCelsius = !value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                'Notification',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Switch(
                value: isNotificationOn,
                onChanged: (value) {
                  setState(() {
                    isNotificationOn = value;
                    realm.write(() {
                      settings.isNotificationOn = value;
                    });
                  });
                },
              ),
              subtitle: InkWell(
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                      context: context, initialTime: notificationTime);
                  if (picked != null && picked != notificationTime) {
                    setState(() {
                      notificationTime = picked;
                      realm.write(() {
                        settings.notificationHour = notificationTime.hour;
                        settings.notificationMinute = notificationTime.minute;
                      });
                    });
                  }
                },
                child: Text(
                  '${notificationTime.format(context)}',
                  style: const TextStyle(
                    fontSize: 50,
                  ),
                ),
              ),
            ),
            const ListTile(
              title: Text(
                'Message Elements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CustomSwitchTile(
              title: 'Temperature',
              value: isTemperatureEnabled,
              onChanged: (value) => setState(
                () {
                  isTemperatureEnabled = value;
                  realm.write(() {
                    settings.isTemperatureEnabled = value;
                  });
                },
              ),
            ),
            CustomSwitchTile(
              title: 'Feels Like',
              value: isFeelsLikeEnabled,
              onChanged: (value) => setState(
                () {
                  isFeelsLikeEnabled = value;
                  realm.write(() {
                    settings.isFeelsLikeEnabled = value;
                  });
                },
              ),
            ),
            CustomSwitchTile(
              title: 'Sky Condition',
              value: isSkyConditionEnabled,
              onChanged: (value) => setState(
                () {
                  isSkyConditionEnabled = value;
                  realm.write(() {
                    settings.isSkyConditionEnabled = value;
                  });
                },
              ),
            ),
            CustomSwitchTile(
              title: 'Wind Condition',
              value: isWindConditionEnabled,
              onChanged: (value) => setState(
                () {
                  isWindConditionEnabled = value;
                  realm.write(() {
                    settings.isWindConditionEnabled = value;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(60, 30)),
                    ),
                    onPressed: () {
                      print('Preview Button Clicked!');
                    },
                    child: const Text('Preview')),
              ),
            ),
            SizedBox(
              height: 14.0,
            ),
            ListTile(
              title: Text(
                'Location Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: isLocated,
                onChanged: (value) async {
                  await AppSettings.openAppSettings();
                  bool permissionStatus = await checkLocationPermissionStatus();
                  print(permissionStatus);
                  // setState(() {
                  //   isLocated = permissionStatus ? value : isLocated;
                  // });
                },
              ),
            ),
            Transform.translate(
              offset: const Offset(0.0, -10.0),
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width * 1.5,
                height: MediaQuery.of(context).size.height * 0.2,
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/images/mncfs.png'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
