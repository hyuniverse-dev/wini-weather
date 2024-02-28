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

Widget movePartScreenAnimation({
  required String asset,
  required Animation<double> animation,
  required double opacity,
  double? width,
  double? height,
}) {
  return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final movement = (animation.value * screenWidth) - (screenWidth);
        return Positioned(
          left: movement,
          height: height ?? screenHeight * 0.35,
          width: width,
          child: Opacity(
            opacity: opacity,
            child: Image.asset(asset),
          ),
        );
      });
}

Widget moveFullScreenAnimation({
  required String asset,
  required Animation<double> animation,
  required double opacity,
  required double top,
  required double bottom,
}) {
  return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final movement = (animation.value * screenWidth) - (screenWidth);
        return Positioned(
          left: movement,
          top: top, // 0,
          bottom: bottom, // 40,
          child: Opacity(
            opacity: opacity,
            child: Image.asset(asset),
          ),
        );
      });
}

Widget moveWithOpacityFullAnimation({
  required String asset,
  required Animation<double> animation,
  // required double opacity,
  required double top,
  required double bottom,
}) {
  return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final movement = (animation.value * screenWidth) - (screenWidth);
        final opacity = (0.2 + animation.value * 0.9).abs().clamp(0.0, 1.0);
        return Positioned(
          left: movement,
          top: top, // 0,
          bottom: bottom, // 40,
          child: Opacity(
            opacity: opacity,
            child: Image.asset(asset),
          ),
        );
      });
}

Widget moveWithOpacityPartAnimation({
  required String asset,
  required Animation<double> animation,
  required double height,
  required bool isFullOpacity,
}) {
  return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final movement = (animation.value * screenWidth) - (screenWidth);
        final opacity = isFullOpacity
            ? (0.2 + animation.value * 0.9).abs().clamp(0.0, 1.0)
            : (1.0 - animation.value * 0.9).abs().clamp(0.0, 1.0);
        return Positioned(
          left: movement,
          height: height,
          child: Opacity(
            opacity: opacity,
            child: Image.asset(asset),
          ),
        );
      });
}

Widget moveWithOpacityAnimation(
    {required String asset,
    required Animation<double> animation,
    required double top,
    required double bottom}) {
  var opacity;
  opacity = Tween<double>(begin: 0.2, end: 1.0).animate(
    CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutSine,
    ),
  );
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final screenWidth = MediaQuery.of(context).size.width;
      final movement = (animation.value * screenWidth) - (screenWidth * 0.4);
      return Positioned(
        left: movement,
        top: top, // 10,
        bottom: bottom, // 40,
        child: Opacity(
          opacity: opacity.value,
          child: Image.asset(asset),
        ),
      );
    },
  );
}

Widget fadeInOutAnimation({
  required String asset,
  required Animation<double> animation,
  double? height,
  double? width,
  double? top,
  double? bottom,
  double? left,
  double? right,
}) {
  return Positioned(
    top: top,
    bottom: bottom,
    left: left,
    right: right,
    height: height,
    width: width,
    child: AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Image.asset(asset),
        );
      },
    ),
  );
}
