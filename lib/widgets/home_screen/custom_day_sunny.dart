import 'dart:math';

import 'package:flutter/material.dart';

import 'custom_weather_animations.dart';
import 'custom_background.dart';

class CustomDaySunny extends StatefulWidget {
  const CustomDaySunny({super.key});

  @override
  State<CustomDaySunny> createState() => _CustomDaySunnyState();
}

class _CustomDaySunnyState extends State<CustomDaySunny>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    _initializeAnimation();
    super.initState();
  }

  void _initializeAnimation() {
    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    )..repeat();

    _rotateAnimation =
        Tween<double>(begin: 0.0, end: 2 * pi).animate(CurvedAnimation(
          parent: _rotateController,
          curve: Curves.linear,
        ));
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackElements(context, _rotateAnimation, _rotateController),
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
          context: context,
          status: 'day_sunny',
        ),
      ),
    );
  }

  Widget _buildBackElements(BuildContext context, Animation<double> animation,
      AnimationController controller) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Positioned(
          top: width.toInt() * 0.325,
          right: height * 0.225,
          width: width * 0.45,
          height: height * 0.45,
          child:
          CustomAnimationContent().daySunnyAnimationBackContent(animation)),
    ]);
  }
}