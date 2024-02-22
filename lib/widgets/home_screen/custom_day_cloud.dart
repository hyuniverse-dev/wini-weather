import 'package:flutter/material.dart';

import 'custom_animation_content.dart';
import 'custom_background.dart';

class CustomDayCloud extends StatefulWidget {
  const CustomDayCloud({super.key});

  @override
  State<CustomDayCloud> createState() => _CustomDayCloudState();
}

class _CustomDayCloudState extends State<CustomDayCloud>
    with TickerProviderStateMixin {
  // Controller
  late AnimationController _leftToRightSlowController;
  late AnimationController _rightToLeftSlowController;
  late AnimationController _rigthToLeftFastController;
  late AnimationController _leftToRightFastController;

  // Animation
  late Animation<double> _leftToRightSlowAnimation;
  late Animation<double> _rigthToLeftSlowAnimation;
  late Animation<double> _rightToLeftFastAnimation;
  late Animation<double> _leftToRightFastAnimation;
  late List<Animation<double>> _moveAnimations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // Very Slow
    _leftToRightSlowController =
        AnimationController(vsync: this, duration: Duration(minutes: 2))
          ..repeat();

    _leftToRightSlowAnimation =
        Tween<double>(begin: 0, end: 2).animate(_leftToRightSlowController);

    // Slow
    _rightToLeftSlowController =
        AnimationController(vsync: this, duration: Duration(minutes: 2))
          ..repeat();

    _rigthToLeftSlowAnimation =
        Tween<double>(begin: 2, end: 0).animate(_rightToLeftSlowController);

    // Fast
    _leftToRightFastController =
        AnimationController(vsync: this, duration: Duration(seconds: 50))
          ..repeat();

    _leftToRightFastAnimation =
        Tween<double>(begin: 0, end: 2).animate(_leftToRightFastController);

    // Middle
    _rigthToLeftFastController =
        AnimationController(vsync: this, duration: Duration(seconds: 35))
          ..repeat();

    _rightToLeftFastAnimation =
        Tween<double>(begin: 2, end: 0).animate(_rigthToLeftFastController);

    _moveAnimations.addAll([
      _leftToRightSlowAnimation,
      _rigthToLeftSlowAnimation,
      _rightToLeftFastAnimation,
      _leftToRightFastAnimation
    ]);
  }

  @override
  void dispose() {
    _leftToRightSlowController.dispose();
    _rightToLeftSlowController.dispose();
    _rigthToLeftFastController.dispose();
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
      child: Center(child: dayCloudBackground()),
    );
  }

  Widget _buildFrontElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .dayCloudAnimationFrontContent(context, _moveAnimations),
    ]);
  }

  Widget _buildBackElements(BuildContext context) {
    return Stack(children: [
      CustomAnimationContent()
          .dayCloudAnimationBackContent(context, _moveAnimations),
    ]);
  }
}
