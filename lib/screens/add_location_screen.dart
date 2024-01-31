import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:morning_weather/models/location_model.dart';
import 'package:morning_weather/services/location_service.dart';
import 'package:morning_weather/utils/alert_utils.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../models/location.dart';
import '../utils/api_utils.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  var currentLocation = 'Seoul';
  var dragDistance = 0.0;
  var config = Configuration.local([Location.schema]);

  final TextEditingController textController = TextEditingController();
  final double minDragDistance = 0;
  final double minVelocity = 0;
  late String? city;
  late Realm realm;
  late var location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          dragDistance += details.delta.dx;
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (dragDistance > minDragDistance &&
              details.velocity.pixelsPerSecond.dx > minVelocity) {
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Text(
                      'Search\nLocation',
                      style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          height: 0.9),
                      textAlign: TextAlign.center,
                    ),
                    Image.asset(
                      'assets/images/search_location.png',
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.black45),
                          children: [
                            TextSpan(text: 'Current Location : '),
                            TextSpan(
                                text: '${currentLocation}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ],
                        ),
                      ),
                    ),
                    TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        labelText: 'Search the weather by area',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 12),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.keyboard_return_rounded),
                          onPressed: () async {
                            final inputValue = textController.text;
                            if (inputValue.isEmpty) {
                              showValidateDialog(context, inputValue);
                            } else {
                              final locationData =
                                  await fetchLocationData(inputValue);
                              if (locationData != null) {
                                var extractData =
                                    await extractLocationData(locationData);
                                if (extractData != null) {
                                  city = extractData['city'] ?? 'Unknown City';
                                  final isOk =
                                      await showConfirmDialog(context, city!);
                                  if (isOk == true) {
                                    // Create Local Database
                                    realm = Realm(config);
                                    realm.write(() {
                                      realm.add(
                                        Location(
                                          getLastPrimaryKey(realm),
                                          locationData.licence,
                                          locationData.latitude,
                                          locationData.longitude,
                                          locationData.name,
                                          city!,
                                          locationData.address.country,
                                        ),
                                      );
                                    });
                                    Navigator.pop(context, true);
                                    textController.clear();
                                  } else if (isOk == false) {
                                    textController.clear();
                                  }
                                } else {
                                  print('No data extracted.');
                                }
                              } else {
                                print('Location data not found');
                              }
                            }
                          },
                        ),
                      ),
                      onSubmitted: (String value) {
                        print(textController.text);
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'How\'s the weather in this place?',
                        style: TextStyle(
                            color: Colors.black45, fontWeight: FontWeight.bold),
                      ),
                    ),
                    LocationWeatherItem(
                      city: 'United Kingdom',
                      icon: Icons.sunny,
                      temperature: '22°C',
                      date: 'Thu, January 10th, 4:32PM',
                    ),
                    LocationWeatherItem(
                      city: 'Australia',
                      icon: Icons.cloud,
                      temperature: '0°C',
                      date: 'Wed, January 10th, 4:32PM',
                    ),
                    LocationWeatherItem(
                      city: 'Papua New Guinea',
                      icon: Icons.grain,
                      temperature: '-8°C',
                      date: 'Wed, January 10th, 4:32PM',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }
}

class LocationWeatherItem extends StatelessWidget {
  final String city;
  final IconData icon;
  final String temperature;
  final String date;

  const LocationWeatherItem({
    super.key,
    required this.city,
    required this.icon,
    required this.temperature,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 46,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(date),
                ],
              ),
              Spacer(),
              Text(
                temperature,
                style: TextStyle(fontSize: 25.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
