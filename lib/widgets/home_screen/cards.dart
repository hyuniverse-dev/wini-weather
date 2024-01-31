import 'package:flutter/material.dart';

Widget buildMainCard(
    double screenWidth,
    double screenHeight,
    String country,
    String location,
    double feelsTemp,
    double currentTemp,
    double hTemp,
    double lTemp) {
  final cardWidth = 280.0;
  final cardHeight = 360.0;

  return Positioned(
    left: screenWidth * 0.03,
    bottom: screenHeight * 0.1,
    width: cardWidth,
    height: cardHeight,
    child: _buildCardContent(
        country, location, feelsTemp, currentTemp, hTemp, lTemp),
  );
}

Widget _buildCardContent(String country, String location, double feelsTemp,
    double currenTemp, double hTemp, double lTemp) {
  return Card(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        )),
    child: Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            location,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Feels Like: ${feelsTemp.toStringAsFixed(0)}°C'),
              Text(
                '${currenTemp.toStringAsFixed(0)}°C',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.thermostat_rounded,
                color: Colors.red,
              ),
              Text('${hTemp.toStringAsFixed(0)}°C'),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.thermostat_rounded,
                color: Colors.blue,
              ),
              Text('${lTemp.toStringAsFixed(0)}°C'),
            ],
          )
        ],
      ),
    ),
  );
}

Widget buildWiniCard() {
  return Center(
      child: Image.asset(
    'assets/images/Member1.png',
  ));
}
