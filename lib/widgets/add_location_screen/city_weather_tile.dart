import 'package:flutter/material.dart';

class CityWeatherTile extends StatelessWidget {
  final int index;
  final String city;
  final IconData weatherIcon;
  final String summary;
  final VoidCallback onRemovePressed;

  const CityWeatherTile({
    super.key,
    required this.index,
    required this.city,
    required this.weatherIcon,
    required this.summary,
    required this.onRemovePressed,
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
                weatherIcon,
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
                    city.length > 10 ? '${city.substring(0, 10)}...' : city,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(summary),
                ],
              ),
              Spacer(),
              index == 0
                  ? Icon(
                      Icons.block,
                      color: Colors.white.withOpacity(1.0),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        size: 26.0,
                        color: Colors.black45,
                      ),
                      onPressed: onRemovePressed,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
