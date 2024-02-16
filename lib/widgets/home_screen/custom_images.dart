import 'package:flutter/material.dart';

Widget buildImageWithOpacityDefault(String asset, int level) {
  var opacity;
  if (level == 1) {
    opacity = 0.1;
  } else if (level == 2) {
    opacity = 0.5;
  } else if (level == 3) {
    opacity = 0.7;
  } else {
    opacity = 1.0;
  }
  return Opacity(
    opacity: opacity,
    child: Image.asset(asset),
  );
}

Widget rotationAnimation(String asset, Animation<double> animation,
    bool clockwise, int level, AnimationController controller) {
  var opacity;
  if (level == 1) {
    opacity = 0.1;
  } else if (level == 2) {
    opacity = 0.5;
  } else if (level == 3) {
    opacity = 0.7;
  } else {
    opacity = 1.0;
  }
  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      final angle = clockwise ? animation.value : -animation.value;
      return Transform.rotate(
        angle: angle,
        child: child,
      );
    },
    child: Opacity(
      opacity: opacity,
      child: Image.asset(asset),
    ),
  );
}
