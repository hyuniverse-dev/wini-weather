import 'package:flutter/material.dart';

import 'custom_animation_content.dart';
import 'custom_background.dart';

class CustomNightSunny extends StatefulWidget {
  const CustomNightSunny({super.key});

  @override
  State<CustomNightSunny> createState() => _CustomNightSunnyState();
}

class _CustomNightSunnyState extends State<CustomNightSunny>
    with TickerProviderStateMixin {
  // Fade Controller & Animation
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    _initializeAnimation();
    super.initState();
  }

  void _initializeAnimation() {
    // Initialize Fade Controller & Animation
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _fadeAnimation =
        Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeOut,
    ));
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
        _buildElements(context, _fadeAnimation, _fadeController),
        _buildBackgroundContent(context),
      ],
    );
  }

  Widget _buildBackgroundContent(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height.toInt() * 0.125,
      left: 0,
      right: 0,
      child: Center(child: nightSunnyBackground()),
    );
  }

  Widget _buildElements(BuildContext context, Animation<double> animation,
      AnimationController controller) {
    return Stack(children: [
      _buildBlendContentItem(context, animation, controller),
      _buildAnimationContentItem(context, animation, controller),
    ]);
  }

  Widget _buildBlendContentItem(BuildContext context,
      Animation<double> animation, AnimationController controller) {
    return Positioned(
        top: MediaQuery.of(context).size.width.toInt() * 0.225,
        right: MediaQuery.of(context).size.height * 0.225,
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.45,
        child: CustomAnimationContent()
            .nightSunnyBlendContent(animation, controller));
    ;
  }

  Widget _buildAnimationContentItem(BuildContext context,
      Animation<double> animation, AnimationController controller) {
    return Positioned(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomAnimationContent()
            .nightSunnyAnimationContent(animation, controller));
  }
}
