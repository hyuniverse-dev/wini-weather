import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mncf_weather/utils/common_utils.dart';
import 'package:mncf_weather/widgets/advertisement/custom_google_banner.dart';

class IntroduceScreen extends StatelessWidget {
  final int sensitivity = 25;
  final bool isLightMode;

  const IntroduceScreen({super.key, required this.isLightMode});

  @override
  Widget build(BuildContext context) {
    String adUnit = io.Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-6607864297606809/7487576309';
    // String adUnit = 'ca-app-pub-6607864297606809/7487576309';
    final backgroundColor = isLightMode ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
    final textColor = isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF);
    final descriptionTextColor =
        isLightMode ? Color(0xFFA49696) : Color(0xFFFFFFFF);
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        print(details.delta.dx);
        if (details.delta.dx < -sensitivity) {
          print(details.delta.dx);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  'Branded App by',
                  style: TextStyle(
                    fontSize: 24,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isLightMode)
                  Column(
                    children: [
                      Text(
                        'MNCF.io',
                        style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      columnSpace(5.0),
                      Image.asset(
                        'assets/images/mncf_logo.png',
                        width: 120,
                        height: 120,
                      ),
                    ],
                  )
                else
                  Container(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset(
                          'assets/images/backgrounds/introduce_night_background.png',
                          width: 200,
                          height: 200,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                'MNCF.io',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              columnSpace(2.0),
                              Image.asset(
                                'assets/images/mncf_logo.png',
                                width: 38,
                                height: 38,
                              ),
                              columnSpace(2.0),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                Spacer(),
                Text(
                  'This product uses data from OpenStreetMap  © OpenStreetMap contributors, available under the Open Database License',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: descriptionTextColor,
                  ),
                ),
                columnSpace(2.0),
                Container(
                  child: CustomGoogleBanner(
                    adUnitId: adUnit,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
