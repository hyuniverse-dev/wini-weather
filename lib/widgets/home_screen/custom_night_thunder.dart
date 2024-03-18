import 'package:flutter/material.dart';

import 'custom_weather_animations.dart';
import 'custom_background.dart';

class CustomNightThunder extends StatefulWidget {
  const CustomNightThunder({super.key});

  @override
  State<CustomNightThunder> createState() => _CustomNightThunderState();
}

class _CustomNightThunderState extends State<CustomNightThunder>
    with TickerProviderStateMixin {
  // Controller
  late AnimationController _shakingController;
  late AnimationController _thunderController;

  // Animation
  late Animation<double> _shakingAnimation1;
  late Animation<double> _shakingAnimation2;
  late Animation<double> _shakingAnimation3;
  late Animation<double> _shakingAnimation4;
  late Animation<double> _thunderFirstAnimation;
  late Animation<double> _thunderSecondAnimation;
  late Animation<double> _thunderThirdAnimation;

  late List<Animation<double>> _moveAnimations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // Move left to right slow
    _shakingController =
    AnimationController(vsync: this, duration: Duration(seconds: 4))
      ..repeat(reverse: true);

    _shakingAnimation1 =
        Tween<double>(begin: 1.1, end: 1.2).animate(_shakingController);

    _shakingAnimation2 =
        Tween<double>(begin: 0.95, end: 0.85).animate(_shakingController);

    _shakingAnimation3 =
        Tween<double>(begin: 1.2, end: 1.3).animate(CurvedAnimation(
          parent: _shakingController,
          curve: Interval(
            0.0,
            0.7,
            curve: Curves.easeInOut,
          ),
        ));

    _shakingAnimation4 =
        Tween<double>(begin: 0.85, end: 0.75).animate(CurvedAnimation(
          parent: _shakingController,
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

    _moveAnimations.addAll([
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
    _shakingController.dispose();
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
          context: context,
          status: 'night_thunder',
        ),
      ),
    );
  }

  Widget _buildFrontElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .dayAndNightThunderAnimationFrontContent(context, _moveAnimations),
    ]);
  }

  Widget _buildBackElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .dayAndNightThunderAnimationBackContent(context, _moveAnimations)
    ]);
  }
}