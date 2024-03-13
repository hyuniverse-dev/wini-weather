import 'package:flutter/material.dart';

import 'custom_weather_animations.dart';
import 'custom_background.dart';

class CustomDayThunder extends StatefulWidget {
  const CustomDayThunder({super.key});

  @override
  State<CustomDayThunder> createState() => _CustomDayThunderState();
}

class _CustomDayThunderState extends State<CustomDayThunder>
    with TickerProviderStateMixin {
  // Controller
  late AnimationController _shakingController1;
  late AnimationController _thunderController;

  // Animation
  late Animation<double> _shakingAnimation1;
  late Animation<double> _shakingAnimation2;
  late Animation<double> _shakingAnimation3;
  late Animation<double> _shakingAnimation4;
  late Animation<double> _thunderFirstAnimation;
  late Animation<double> _thunderSecondAnimation;
  late Animation<double> _thunderThirdAnimation;

  late List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // Move left to right slow
    _shakingController1 =
    AnimationController(vsync: this, duration: Duration(seconds: 4))
      ..repeat(reverse: true);

    _shakingAnimation1 =
        Tween<double>(begin: 1.1, end: 1.2).animate(_shakingController1);

    _shakingAnimation2 =
        Tween<double>(begin: 0.95, end: 0.85).animate(_shakingController1);

    _shakingAnimation3 =
        Tween<double>(begin: 1.2, end: 1.3).animate(CurvedAnimation(
          parent: _shakingController1,
          curve: Interval(
            0.0,
            0.7,
            curve: Curves.easeInOut,
          ),
        ));

    _shakingAnimation4 =
        Tween<double>(begin: 0.85, end: 0.75).animate(CurvedAnimation(
          parent: _shakingController1,
          curve: Interval(
            0.0,
            0.9,
            curve: Curves.easeInOut,
          ),
        ));

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

    _thunderThirdAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _thunderController,
          curve: Interval(0.0, 0.2, curve: Curves.easeOut)),
    );

    _animations.addAll([
      _shakingAnimation1,
      _shakingAnimation2,
      _shakingAnimation3,
      _shakingAnimation4,
      _thunderFirstAnimation,
      _thunderSecondAnimation,
      _thunderThirdAnimation
    ]);
  }

  @override
  void dispose() {
    _shakingController1.dispose();
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
          status: 'day_thunder',
        ),
      ),
    );
  }

  Widget _buildFrontElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .dayAndNightThunderAnimationFrontContent(context, _animations),
    ]);
  }

  Widget _buildBackElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .dayAndNightThunderAnimationBackContent(context, _animations)
    ]);
  }
}