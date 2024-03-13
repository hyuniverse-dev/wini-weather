import 'package:flutter/material.dart';

import 'custom_weather_animations.dart';
import 'custom_background.dart';

class CustomNightCloud extends StatefulWidget {
  const CustomNightCloud({super.key});

  @override
  State<CustomNightCloud> createState() => _CustomNightCloudState();
}

class _CustomNightCloudState extends State<CustomNightCloud>
    with TickerProviderStateMixin {
  // Controller
  late AnimationController _leftToRightSlowController;
  late AnimationController _rightToLeftSlowController;
  late AnimationController _rightToLeftFastController;
  late AnimationController _leftToRightFastController;

  // Animation
  late Animation<double> _leftToRightSlowAnimation;
  late Animation<double> _rightToLeftSlowAnimation;
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
    AnimationController(vsync: this, duration: Duration(minutes: 20))
      ..repeat();

    _leftToRightSlowAnimation =
        Tween<double>(begin: 0, end: 2).animate(_leftToRightSlowController);

    // Move right to left slow
    _rightToLeftSlowController =
    AnimationController(vsync: this, duration: Duration(minutes: 20))
      ..repeat();

    _rightToLeftSlowAnimation =
        Tween<double>(begin: 2, end: 0).animate(_rightToLeftSlowController);

    // Move left to right fast
    _leftToRightFastController =
    AnimationController(vsync: this, duration: Duration(seconds: 50))
      ..repeat();

    _leftToRightFastAnimation =
        Tween<double>(begin: 0, end: 2).animate(_leftToRightFastController);

    // Move right to left fast
    _rightToLeftFastController =
    AnimationController(vsync: this, duration: Duration(seconds: 35))
      ..repeat();

    _rightToLeftFastAnimation =
        Tween<double>(begin: 2, end: 0).animate(_rightToLeftFastController);

    _animations.addAll([
      _leftToRightSlowAnimation,
      _rightToLeftSlowAnimation,
      _rightToLeftFastAnimation,
      _leftToRightFastAnimation
    ]);
  }

  @override
  void dispose() {
    _leftToRightSlowController.dispose();
    _rightToLeftSlowController.dispose();
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
          status: 'night_cloud',
        ),
      ),
    );
  }

  Widget _buildFrontElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .nightCloudAnimationFrontContent(context, _animations),
    ]);
  }

  Widget _buildBackElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .nightCloudAnimationBackContent(context, _animations),
    ]);
  }
}