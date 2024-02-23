import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/image_painter_service.dart';
import 'custom_images.dart';

class CustomAnimationContent {
  // Day Sunny Content
  Widget daySunnyAnimationContent(
      Animation<double> animation, AnimationController controller) {
    return Stack(
      children: [
        buildImageWithOpacityDefault(
            'assets/images/elements/day_sunny1.png', 4),
        rotationAnimation('assets/images/elements/day_sunny2.png', animation,
            true, 4, controller),
        buildImageWithOpacityDefault(
            'assets/images/elements/day_sunny3.png', 4),
        rotationAnimation('assets/images/elements/day_sunny4.png', animation,
            false, 4, controller),
        buildImageWithOpacityDefault(
            'assets/images/elements/day_sunny5.png', 4),
        rotationAnimation('assets/images/elements/day_sunny6.png', animation,
            true, 4, controller),
        buildImageWithOpacityDefault(
            'assets/images/elements/day_sunny7.png', 4),
      ],
    );
  }

  Widget nightSunnyAnimationContent(
      Animation<double> animation, AnimationController controller) {
    return Stack(
      children: [
        fadeAnimation('assets/images/elements/night_sunny2.png', animation,
            controller, true),
        fadeAnimation('assets/images/elements/night_sunny3.png', animation,
            controller, false),
      ],
    );
  }

  // Night Sunny Content
  Widget nightSunnyBlendContent(
      Animation<double> animation, AnimationController controller) {
    return FutureBuilder<List<ui.Image>>(
      future: Future.wait([
        loadImage('assets/images/elements/night_sunny1.png'),
        loadImage('assets/images/elements/night_sunny4.png')
      ]),
      builder: (context, snapshot) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Stack(
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: ImagePainterService(
                  image1: snapshot.data![0],
                  image2: snapshot.data![1],
                  animation: animation,
                ),
              )
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget dayCloudAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        moveAnimation(
            'assets/images/elements/day_cloud1.png', animation[3], 1.0),
        moveAnimation(
            'assets/images/elements/day_cloud4.png', animation[2], 1.0),
      ],
    );
  }

  Widget dayCloudAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        moveAnimation(
            'assets/images/elements/day_cloud2.png', animation[0], 0.7),
        moveAnimation(
            'assets/images/elements/day_cloud3.png', animation[1], 1.0),
      ],
    );
  }

  Widget nightCloudAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        moveAnimation(
            'assets/images/elements/day_cloud1.png', animation[3], 0.7),
        moveAnimation(
            'assets/images/elements/day_cloud4.png', animation[2], 0.7),
      ],
    );
  }

  Widget nightCloudAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        moveAnimation(
            'assets/images/elements/day_cloud2.png', animation[0], 0.4),
        moveAnimation(
            'assets/images/elements/day_cloud3.png', animation[1], 0.6),
      ],
    );
  }
}
