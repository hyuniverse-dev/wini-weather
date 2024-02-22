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

Widget fadeAnimation(String asset, Animation<double> animation,
    AnimationController controller, bool isFirst) {
  var opacity;
  if (isFirst) {
    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: controller, curve: Interval(0.0, 0.5, curve: Curves.easeIn)),
    );
  } else {
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: controller, curve: Interval(0.5, 1.0, curve: Curves.easeIn)),
    );
  }

  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      return Opacity(
        opacity: opacity.value,
        child: Image.asset(asset),
      );
    },
  );
}

Widget moveAnimation(
    String asset, Animation<double> animation, double opacity) {
  return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final movement = (animation.value * screenWidth) - (screenWidth);
        return Positioned(
          left: movement,
          height: MediaQuery.of(context).size.height * 0.35,
          child: Opacity(
            opacity: opacity,
            child: Image.asset(asset),
          ),
        );
      });
}
