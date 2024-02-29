import 'package:flutter/material.dart';
import 'package:mncf_weather/models/weather.dart';
import 'dart:convert';

class WeatherFutureBuilder extends StatelessWidget {
  final Future<WeatherResponse> weatherData;

  const WeatherFutureBuilder({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherResponse>(
      future: weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(),
            Image.asset(
              'assets/images/DogProgress.gif',
              width: 60.0,
              height: 60.0,
            )
          ]);
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final weather = snapshot.data!;
          final country = weather.location.country;
          final name = weather.location.name;
          final lat = weather.location.latitude;
          final lon = weather.location.longitude;
          final localTime = weather.location.localtime;
          final updateTime = weather.current.updateTime;
          final tempC = weather.current.tempC;
          final tempF = weather.current.tempF;
          final feelsC = weather.current.feelsC;
          final feelsF = weather.current.feelsF;
          final code = weather.current.condition.code;
          final message = weather.current.condition.text ?? "No Data";
          final humidity = weather.current.humidity;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "국가명: $country",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "지역명: $name",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "현지시간: $localTime",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "업데이트 시간: $updateTime",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "현재 온도(섭씨): $tempC",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "현재 온도(화씨): $tempF",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "상태 코드: $code",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "상태 메시지: ${decodeUtf8String(message)}",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "위도: $lat",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "경도: $lon",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "체감온도(섭씨): $feelsC",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "체감온도(화씨): $feelsF",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "습도: $humidity",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        } else {
          return Text("No Data");
        }
      },
    );
  }
}

String decodeUtf8String(String message) {
  return utf8.decode(latin1.encode(message));
}
