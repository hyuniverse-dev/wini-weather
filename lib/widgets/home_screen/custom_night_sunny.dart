import 'package:flutter/material.dart';

import 'custom_weather_animations.dart';
import 'custom_background.dart';

class CustomNightSunny extends StatefulWidget {
  const CustomNightSunny({super.key});

  @override
  State<CustomNightSunny> createState() => _CustomNightSunnyState();
}

class _CustomNightSunnyState extends State<CustomNightSunny>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation1;
  late Animation<double> _fadeAnimation2;

  late List<Animation<double>> _animations = [];

  @override
  void initState() {
    _initializeAnimation();
    super.initState();
  }

  void _initializeAnimation() {
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeAnimation1 =
        Tween<double>(begin: 0.2, end: 1.0).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.bounceIn,
        ));

    _fadeAnimation2 =
        Tween<double>(begin: 1.0, end: 0.2).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.bounceIn,
        ));

    _animations.addAll([
      _fadeAnimation1,
      _fadeAnimation2,
    ]);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildElements(context, _animations),
        _buildBackgroundContent(context),
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
          status: 'night_sunny',
        ),
      ),
    );
  }

  Widget _buildElements(BuildContext context, List<Animation<double>> animations) {
    return Stack(children: [
      _buildBackContent(context, animations[0]),
      _buildBlendContent(context, animations[1]),
    ]);
  }

  Widget _buildBlendContent(BuildContext context, Animation<double> animation) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Positioned(
        width: width * 0.45,
        child: CustomAnimationContent().nightSunnyBlendBackContent(animation));
    ;
  }

  Widget _buildBackContent(BuildContext context, Animation<double> animation) {
    return Positioned(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomAnimationContent()
            .nightSunnyAnimationBackContent(_animations));
  }
}