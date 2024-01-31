import 'package:flutter/material.dart';
import 'package:morning_weather/widgets/settings_screen/switch_tile.dart';
import 'package:realm/realm.dart';
import 'package:uuid/uuid.dart' as uuid_pkg;

import '../models/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
  late TimeOfDay notificationTime =
      TimeOfDay(hour: notificationHour, minute: notificationMinute);

  @override
  void initState() {
    super.initState();
    // var config = Configuration.local([Settings.schema]);
    realm = Realm(config);
    settings = realm.all<Settings>().lastOrNull;
    print(realm);
    if (settings == null) {
      realm.write(() {
        realm.add(
          Settings(
            uid.v4(),
            true,
            true,
            9,
            00,
            false,
            false,
            false,
            false,
          ),
        );
      });
    }


    isCelsius = settings.isCelsius;
    isNotificationOn = settings.isNotificationOn;
    notificationHour = settings.notificationHour;
    notificationMinute = settings.notificationMinute;
    isTemperatureEnabled = settings.isTemperatureEnabled;
    isFeelsLikeEnabled = settings.isFeelsLikeEnabled;
    isSkyConditionEnabled = settings.isSkyConditionEnabled;
    isWindConditionEnabled = settings.isWindConditionEnabled;
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
                    onPressed: () {
                      print('Preview Button Clicked!');
                    },
                    child: const Text('Preview')),
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
