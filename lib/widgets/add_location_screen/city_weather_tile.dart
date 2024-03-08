import 'package:flutter/material.dart';
import 'package:mncf_weather/utils/common_utils.dart';

class CityWeatherTile extends StatelessWidget {
  final int index;
  final String city;
  final String skyCondition;
  final String summary;
  final String temperature;
  final VoidCallback onRemovePressed;
  final Color backgroundColor;
  final Color textColor;
  final Color textFieldColor;

  const CityWeatherTile({
    super.key,
    required this.index,
    required this.city,
    required this.skyCondition,
    required this.summary,
    required this.temperature,
    required this.onRemovePressed,
    required this.backgroundColor,
    required this.textColor,
    required this.textFieldColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          // color: backgroundColor,
          decoration: BoxDecoration(
            border: Border.all(
              color: textColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
            color: textFieldColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                rowSpace(1.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.length > 10 ? '${city.substring(0, 11)}...' : city,
                      style: TextStyle(
                        fontSize: 20,
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
                rowSpace(0.5)
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: -23,
          child: index == 0
              ? Icon(
                  Icons.block,
                  color: Colors.transparent,
                )
              : IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    size: 26.0,
                    color: Color(0xFFEF3B08),
                  ),
                  onPressed: onRemovePressed,
                ),
        )
      ]),
    );
  }
}
