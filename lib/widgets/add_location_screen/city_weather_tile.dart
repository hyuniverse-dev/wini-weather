import 'package:flutter/material.dart';
import 'package:mncf_weather/utils/common_utils.dart';
import 'package:defer_pointer/defer_pointer.dart';

class CityWeatherTile extends StatelessWidget {
  final int index;
  final String city;
  final String skyCondition;
  final String summary;
  final String temperature;
  final Color boxBackgroundColor;
  final Color textColor;
  final Color textFieldColor;
  final Color buttonBackgroundColor;

  const CityWeatherTile({
    super.key,
    required this.index,
    required this.city,
    required this.skyCondition,
    required this.summary,
    required this.temperature,
    required this.boxBackgroundColor,
    required this.textColor,
    required this.textFieldColor,
    required this.buttonBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
        right: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: textColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
          color: boxBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  rowSpace(1.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.length > 20
                            ? '${city.substring(0, 21)}\n${city.substring(21, 40)}...'
                            : city,
                        style: TextStyle(
                          fontSize: city.length > 20 ? 15 : 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        summary,
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    temperature,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 36,
                    ),
                  ),
                  Image.asset(
                    'assets/images/wini/$skyCondition.png',
                    width: 38.0,
                  ),
                  rowSpace(0.5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
