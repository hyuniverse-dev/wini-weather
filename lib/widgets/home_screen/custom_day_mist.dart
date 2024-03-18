import 'package:flutter/material.dart';

import 'custom_weather_animations.dart';
import 'custom_background.dart';

class CustomDayMist extends StatefulWidget {
  const CustomDayMist({super.key});

  @override
  State<CustomDayMist> createState() => _CustomDayMistState();
}

class _CustomDayMistState extends State<CustomDayMist>
    with TickerProviderStateMixin {
  // Controller
  late AnimationController _leftToRightSlowController;
  late AnimationController _rightToLeftFastController;
  late AnimationController _leftToRightFastController;

  // Animation
  late Animation<double> _leftToRightSlowAnimation;
  late Animation<double> _rightToLeftFastAnimation;
  late Animation<double> _leftToRightFastAnimation;
  late List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // Move left to right slow
    _leftToRightSlowController =
    AnimationController(vsync: this, duration: Duration(minutes: 2))
      ..repeat();

    _leftToRightSlowAnimation =
        Tween<double>(begin: 0, end: 1).animate(_leftToRightSlowController);

    // Move left to right fast
    _leftToRightFastController =
    AnimationController(vsync: this, duration: Duration(seconds: 40))
      ..repeat();

    _leftToRightFastAnimation =
        Tween<double>(begin: 0, end: 1).animate(_leftToRightFastController);

    // Move right to left fast
    _rightToLeftFastController =
    AnimationController(vsync: this, duration: Duration(seconds: 35))
      ..repeat();

    _rightToLeftFastAnimation =
        Tween<double>(begin: 1, end: 0).animate(_rightToLeftFastController);

    _animations.addAll([
      _leftToRightSlowAnimation,
      _leftToRightFastAnimation,
      _rightToLeftFastAnimation,
    ]);
  }

  @override
  void dispose() {
    _leftToRightSlowController.dispose();
    _rightToLeftFastController.dispose();
    _leftToRightFastController.dispose();
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
          context: context,
          status: 'day_mist',
        ),
      ),
    );
  }

  Widget _buildFrontElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .dayMistAnimationFrontContent(context, _animations),
    ]);
  }

  Widget _buildBackElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent().dayMistAnimationBackContent(context),
    ]);
  }
}