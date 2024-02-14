import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:morning_weather/services/settings_data_service.dart';
import 'package:morning_weather/utils/shared_preferences_utils.dart';
import 'package:morning_weather/widgets/settings_screen/switch_tile.dart';
import 'package:realm/realm.dart';
import 'package:uuid/uuid.dart' as uuid_pkg;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/settings.dart';
import '../services/location_permission_service.dart';
import '../services/notification_service.dart';
import '../utils/location_permission_utils.dart';

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
  late bool isCelsius = true;
  late bool isNotificationOn = true;
  late int notificationHour = 0;
  late int notificationMinute = 0;
  late bool isTemperatureEnabled = true;
  late bool isFeelsLikeEnabled = true;
  late bool isSkyConditionEnabled = true;
  late bool isWindConditionEnabled = false;
  late bool isLocated = false;
  late TimeOfDay notificationTime =
      TimeOfDay(hour: notificationHour, minute: notificationMinute);
  late SettingsDataService settingsDataService;
  late NotificationService notificationService;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSettings();
  }

  void _initSettings() async {
    realm = Realm(config);
    bool located = await requestLocationPermission();
    notificationService = NotificationService(realm);
    await notificationService.init();
    settingsDataService = SettingsDataService(realm);
    settings = await settingsDataService.fetchSettings();
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
      SettingsDataService settingsDataService = SettingsDataService(realm);
      settingsDataService.createDefaultSettings();
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
      _refreshLocationPermissionStatus();
    }
  }

  void _refreshLocationPermissionStatus() async {
    final isAllow = await refreshLocationPermissionStatus();
    setState(() {
      isLocated = isAllow;
    });
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
                  // settings.isCelsius = value;
                  settingsDataService.updateSettings(isCelsius: value);
                },
              ),
            ),
            CustomSwitchTile(
              title: '°F',
              value: !isCelsius,
              onChanged: (value) => setState(
                () {
                  isCelsius = !value;
                  settingsDataService.updateSettings(isCelsius: !value);
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
                onChanged: (value) async {
                  setState(() {
                    isNotificationOn = value;
                    settingsDataService.updateSettings(isNotificationOn: value);
                  });
                  setNotificationOn(isNotificationOn);
                  if (isNotificationOn) {
                    print('Notification On----------');
                    FlutterBackgroundService().startService();
                    setNotificationOn(true);
                    print('Notification On----------');
                  } else {
                    print('Notification Off----------');
                    FlutterBackgroundService().invoke("stopService");
                    setNotificationOn(false);
                    print('Notification Off----------');
                  }
                },
              ),
              subtitle: InkWell(
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                      context: context, initialTime: notificationTime);
                  if (picked != null && picked != notificationTime) {
                    setState(() {
                      notificationTime = picked;
                      settingsDataService.updateSettings(
                          notificationHour: notificationTime.hour,
                          notificationMinute: notificationTime.minute);
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
                  settingsDataService.updateSettings(
                      isTemperatureEnabled: value);
                },
              ),
            ),
            CustomSwitchTile(
              title: 'Feels Like',
              value: isFeelsLikeEnabled,
              onChanged: (value) => setState(
                () {
                  isFeelsLikeEnabled = value;
                  settingsDataService.updateSettings(isFeelsLikeEnabled: value);
                },
              ),
            ),
            CustomSwitchTile(
              title: 'Sky Condition',
              value: isSkyConditionEnabled,
              onChanged: (value) => setState(
                () {
                  isSkyConditionEnabled = value;
                  settingsDataService.updateSettings(
                      isSkyConditionEnabled: value);
                },
              ),
            ),
            CustomSwitchTile(
              title: 'Wind Condition',
              value: isWindConditionEnabled,
              onChanged: (value) => setState(
                () {
                  isWindConditionEnabled = value;
                  settingsDataService.updateSettings(
                      isWindConditionEnabled: value);
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
                    onPressed: () async {
                      print('Preview Button Clicked!');
                      await notificationService.showNotification();
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
