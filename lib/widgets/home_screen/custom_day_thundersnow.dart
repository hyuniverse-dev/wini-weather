import 'package:flutter/material.dart';

import 'custom_weather_animations.dart';
import 'custom_background.dart';

class CustomDayThundersnow extends StatefulWidget {
  const CustomDayThundersnow({super.key});

  @override
  State<CustomDayThundersnow> createState() => _CustomDayThundersnowState();
}

class _CustomDayThundersnowState extends State<CustomDayThundersnow>
    with TickerProviderStateMixin {
  // Controller
  late AnimationController _cloudController;
  late AnimationController _snowController1;
  late AnimationController _snowController2;
  late AnimationController _thunderController;

  // Animation
  late Animation<double> _cloudAnimation1;
  late Animation<double> _cloudAnimation2;
  late Animation<double> _cloudAnimation3;
  late Animation<double> _cloudAnimation4;
  late Animation<double> _snowAnimation1;
  late Animation<double> _snowAnimation2;
  late Animation<double> _snowAnimation3;
  late Animation<double> _thunderFirstAnimation;
  late Animation<double> _thunderSecondAnimation;

  late List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _cloudController =
        AnimationController(vsync: this, duration: Duration(minutes: 2))
          ..repeat();

    _cloudAnimation1 =
        Tween<double>(begin: 0.7, end: 1.5).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeIn,
    ));

    _cloudAnimation2 =
        Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeOut,
    ));

    _cloudAnimation3 =
        Tween<double>(begin: 1.3, end: 1.5).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeOut,
    ));

    _cloudAnimation4 =
        Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.easeOut,
    ));

    _snowController1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    _snowAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _snowController1, curve: Curves.easeInOutSine),
    );

    _snowAnimation2 = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _snowController1,
          curve: Interval(0.3, 0.8, curve: Curves.easeInOutSine)),
    );

    _snowController2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();

    _snowAnimation3 = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _snowController2, curve: Curves.easeInOutSine),
    );

    _thunderController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();

    _thunderFirstAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _thunderController,
          curve: Interval(0.0, 0.3, curve: Curves.easeOut)),
    );

    _thunderSecondAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _thunderController,
          curve: Interval(0.3, 0.8, curve: Curves.easeOut)),
    );

    _animations.addAll([
      _cloudAnimation1,
      _cloudAnimation2,
      _cloudAnimation3,
      _cloudAnimation4,
      _snowAnimation1,
      _snowAnimation2,
      _snowAnimation3,
      _thunderFirstAnimation,
      _thunderSecondAnimation
    ]);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _snowController1.dispose();
    _snowController2.dispose();
    _thunderController.dispose();
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
          status: 'day_snow_thunder',
        ),
      ),
    );
  }

  Widget _buildFrontElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent().dayAndNightThundersnowAnimationFrontContent(
        context: context,
        animation: _animations,
        isDay: true,
      ),
    ]);
  }

  Widget _buildBackElements(BuildContext context) {
    return Stack(children: [
      // Add the back elements here
    ]);
  }
}
