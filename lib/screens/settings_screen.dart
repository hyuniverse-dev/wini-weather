import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:mncf_weather/services/settings_data_service.dart';
import 'package:mncf_weather/utils/common_utils.dart';
import 'package:mncf_weather/utils/time_picker_utils.dart';
import 'package:mncf_weather/widgets/settings_screen/switch_tile.dart';
import 'package:realm/realm.dart';
import 'package:uuid/uuid.dart' as uuid_pkg;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../models/settings.dart';
import '../services/location_permission_service.dart';
import '../services/notification_service.dart';
import '../services/shared_preferences_service.dart';
import '../utils/location_permission_utils.dart';

class SettingsScreen extends StatefulWidget {
  final bool isLightMode;

  const SettingsScreen({super.key, required this.isLightMode});

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
  late bool isNotificationOn = false;
  late int notificationHour = 00;
  late int notificationMinute = 00;
  late bool isTemperatureEnabled = false;
  late bool isFeelsLikeEnabled = false;
  late bool isSkyConditionEnabled = false;
  late bool isWindConditionEnabled = false;
  late bool isLocated = false;
  late TimeOfDay? notificationTime =
      TimeOfDay(hour: notificationHour, minute: notificationMinute);
  late SettingsDataService settingsDataService;
  late NotificationService notificationService;
  late Color themeMode = Color(0xFFFFF9F6);
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
          TimeOfDay(hour: notificationHour!, minute: notificationMinute!);
      themeMode = widget.isLightMode ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
    });
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
      backgroundColor: themeMode,
      appBar: AppBar(
        foregroundColor:
            widget.isLightMode ? Color(0xFF000000) : Color(0xFFE9DEDA),
        backgroundColor: themeMode,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Temperature settings',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.isLightMode
                        ? Color(0xFF000000)
                        : Color(0xFFFFFFFF)),
              ),
            ),
            CustomSwitchTile(
              title: '°C(Celsius)',
              isLightMode: widget.isLightMode,
              value: isCelsius!,
              onChanged: (value) => setState(
                () {
                  isCelsius = value;
                  settingsDataService.updateSettings(isCelsius: value);
                  Provider.of<SettingsProvider>(context, listen: false)
                      .isCelsius = value;
                },
              ),
            ),
            CustomSwitchTile(
              title: '°F(Fahrenheit)',
              isLightMode: widget.isLightMode,
              value: !isCelsius!,
              onChanged: (value) => setState(
                () {
                  isCelsius = !value;
                  settingsDataService.updateSettings(isCelsius: !value);
                },
              ),
            ),
            columnSpaceWithDivider(3.0, Color(0xFFE9DEDA)),
            Column(children: [
              CustomSwitchTile(
                title: 'Notification',
                value: isNotificationOn!,
                isLightMode: widget.isLightMode,
                fontSize: 24.0,
                isBold: true,
                onChanged: (value) async {
                  setState(() {
                    isNotificationOn = value;
                    settingsDataService.updateSettings(isNotificationOn: value);
                  });
                  await SharedPreferencesService()
                      .setNotificationStatus(isNotificationOn!);
                  if (isNotificationOn!) {
                    print('Notification On----------');
                    FlutterBackgroundServiceIOS().start();
                    print(
                        'Notification On----------> ${await FlutterBackgroundService().isRunning()}');
                  } else {
                    print('Notification Off----------');
                    FlutterBackgroundService().invoke("stopService");
                    print(
                        'Notification Off----------> ${await FlutterBackgroundService().isRunning()}');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    InkWell(
                      // splashColor: Color(0xFFEB6440),
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                            context: context, initialTime: notificationTime!);
                        if (picked != null && picked != notificationTime) {
                          setState(() {
                            notificationTime = picked;
                            settingsDataService.updateSettings(
                                notificationHour: notificationTime!.hour,
                                notificationMinute: notificationTime!.minute);
                          });
                        }
                      },
                      child: Text(
                        '${notificationTime!.format(context)}',
                        style: TextStyle(
                          color: widget.isLightMode
                              ? Color(0xFF000000)
                              : Color(0xFFFFFFFF),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      child: Text(
                        'Change',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: widget.isLightMode
                                ? Color(0xFFEB6440)
                                : Color(0xFFFFFFFF)),
                      ),
                      style: ButtonStyle(
                        backgroundColor: widget.isLightMode
                            ? MaterialStateProperty.all(Color(0xFFFFE9DD))
                            : MaterialStateProperty.all(Color(0xFF57585E)),
                        minimumSize:
                            MaterialStateProperty.all(const Size(56, 28)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 0.0)),
                      ),
                      onPressed: () async {
                        TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: notificationTime!,
                            builder: (context, child) {
                              return Theme(
                                child: child!,
                                data: CustomTimePickerTheme.theme,
                              );
                            });
                        if (picked != null && picked != notificationTime) {
                          setState(() {
                            notificationTime = picked;
                            settingsDataService.updateSettings(
                                notificationHour: notificationTime!.hour,
                                notificationMinute: notificationTime!.minute);
                          });
                        }
                      },
                    ),
                    rowSpace(1.0)
                  ],
                ),
              )
            ]),
            columnSpaceWithDivider(3.0, Color(0xFFE9DEDA)),
            SizedBox(
              height: 14.0,
            ),
            CustomSwitchTile(
              title: 'Current location',
              fontSize: 24.0,
              isBold: true,
              isLightMode: widget.isLightMode,
              value: isLocated,
              onChanged: (value) async {
                await AppSettings.openAppSettings();
                bool permissionStatus = await checkLocationPermissionStatus();
                print('>>> Permission Status: $permissionStatus'); // debug
              },
            ),
            columnSpace(3.0),
            Transform.translate(
              offset: const Offset(0.0, -10.0),
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                    'assets/images/advertisement/settings_screen_advertisement.png'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingsProvider with ChangeNotifier {
  late bool _isCelsius = true;

  SettingsProvider() {
    _loadInitialSettings();
  }

  void _loadInitialSettings() async {
    var config = Configuration.local([Settings.schema]);
    var realm = Realm(config);
    var settings = realm.all<Settings>().lastOrNull;
    if (settings != null) {
      _isCelsius = settings.isCelsius;
    } else {
      _isCelsius = true;
    }
    notifyListeners();
  }

  bool get isCelsius => _isCelsius;

  set isCelsius(bool value) {
    _isCelsius = value;
    notifyListeners();
  }
}
