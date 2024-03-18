import 'package:flutter/material.dart';

import 'custom_weather_animations.dart';
import 'custom_background.dart';

class CustomNightDrizzle extends StatefulWidget {
  const CustomNightDrizzle({super.key});

  @override
  State<CustomNightDrizzle> createState() => _CustomNightDrizzleState();
}

class _CustomNightDrizzleState extends State<CustomNightDrizzle>
    with TickerProviderStateMixin {
  // Controller
  late AnimationController _leftToRightSlowController;
  late AnimationController _rightToLeftSlowController;
  late AnimationController _leftToRightFastController;
  late AnimationController _rightToLeftFastController;
  late AnimationController _drizzleController;

  // Animation
  late Animation<double> _leftToRightSlowAnimation;
  late Animation<double> _rightToLeftSlowAnimation;
  late Animation<double> _leftToRightFastAnimation;
  late Animation<double> _rightToLeftFastAnimation;
  late Animation<double> _drizzleFirstAnimation;
  late Animation<double> _drizzleSecondAnimation;

  late List<Animation<double>> _moveAnimations = [];

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
    AnimationController(vsync: this, duration: Duration(minutes: 2))
      ..repeat();

    _leftToRightFastAnimation =
        Tween<double>(begin: -1.5, end: 1).animate(_leftToRightFastController);

    // Move right to left fast
    _rightToLeftSlowController =
    AnimationController(vsync: this, duration: Duration(minutes: 3))
      ..repeat();

    _rightToLeftSlowAnimation =
        Tween<double>(begin: 2, end: -1.0).animate(_rightToLeftSlowController);

    // Move right to left fast
    _rightToLeftFastController =
    AnimationController(vsync: this, duration: Duration(minutes: 2))
      ..repeat();

    _rightToLeftFastAnimation =
        Tween<double>(begin: 0.5, end: -1).animate(_rightToLeftFastController);

    _drizzleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _drizzleFirstAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _drizzleController,
          curve: Interval(0.0, 0.5, curve: Curves.easeInOut)),
    );

    _drizzleSecondAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _drizzleController,
          curve: Interval(0.0, 0.5, curve: Curves.easeInOut)),
    );

    _moveAnimations.addAll([
      _leftToRightSlowAnimation,
      _rightToLeftSlowAnimation,
      _leftToRightFastAnimation,
      _rightToLeftFastAnimation,
      _drizzleFirstAnimation,
      _drizzleSecondAnimation
    ]);
  }

  @override
  void dispose() {
    _leftToRightSlowController.dispose();
    _rightToLeftSlowController.dispose();
    _rightToLeftFastController.dispose();
    _leftToRightFastController.dispose();
    _drizzleController.dispose();
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
          status: 'night_drizzle',
        ),
      ),
    );
  }

  Widget _buildFrontElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .nightDrizzleAnimationFrontContent(context, _moveAnimations),
    ]);
  }

  Widget _buildBackElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .nightDrizzleAnimationBackContent(context, _moveAnimations)
    ]);
  }
}