import 'package:flutter/material.dart';

import 'custom_weather_animations.dart';
import 'custom_background.dart';

class CustomDayRain extends StatefulWidget {
  const CustomDayRain({super.key});

  @override
  State<CustomDayRain> createState() => _CustomDayRainState();
}

class _CustomDayRainState extends State<CustomDayRain>
    with TickerProviderStateMixin {
  // Controller
  late AnimationController _cloudController;
  late AnimationController _rainController1;
  late AnimationController _rainController2;

  // Animation
  late Animation<double> _cloudAnimation1;
  late Animation<double> _cloudAnimation2;
  late Animation<double> _cloudAnimation3;
  late Animation<double> _cloudAnimation4;
  late Animation<double> _rainAnimation1;
  late Animation<double> _rainAnimation2;
  late Animation<double> _rainAnimation3;
  late Animation<double> _rainAnimation4;

  late List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // Move left to right slow
    _cloudController =
        AnimationController(vsync: this, duration: Duration(minutes: 2))
          ..repeat();

    _cloudAnimation1 =
        Tween<double>(begin: 0.0, end: 3.0).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeOut,
    ));

    _cloudAnimation2 =
        Tween<double>(begin: 0.7, end: 1.5).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeIn,
    ));

    _cloudAnimation3 =
        Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeOut,
    ));

    _cloudAnimation4 =
        Tween<double>(begin: 1.2, end: 1.5).animate(_cloudController);

    _rainController1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _rainAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rainController1, curve: Curves.easeOut),
    );

    _rainAnimation2 = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _rainController1,
          curve: Interval(0.3, 0.8, curve: Curves.easeOut)),
    );

    _rainController2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _rainAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _rainController2,
          curve: Curves.bounceIn),
    );

    _rainAnimation4 = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _rainController2,
          curve: Curves.easeOut),
    );

    _animations.addAll([
      _cloudAnimation1,
      _cloudAnimation2,
      _cloudAnimation3,
      _cloudAnimation4,
      _rainAnimation1,
      _rainAnimation2,
      _rainAnimation3,
      _rainAnimation4
    ]);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _rainController1.dispose();
    _rainController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackElements(context),
        _buildBackgroundContent(context),
        _buildFrontElements(context),
      ],
    );
  }

  Widget _buildBackgroundContent(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height.toInt() * 0.125,
      left: 0,
      right: 0,
      child: Center(
        child: getBackgroundImage(
          status: 'day_rain',
        ),
      ),
    );
  }

  Widget _buildFrontElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .dayRainAnimationFrontContent(context, _animations),
    ]);
  }

  Widget _buildBackElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .dayRainAnimationBackContent(context, _animations)
    ]);
  }
}
