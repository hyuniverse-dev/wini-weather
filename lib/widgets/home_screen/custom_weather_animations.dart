import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/image_painter_service.dart';
import 'custom_animation_effects.dart';

class CustomAnimationContent {
  Widget daySunnyAnimationBackContent(Animation<double> animation) {
    return Stack(
      children: [
        Image.asset('assets/images/elements/day_sunny1.png'),
        rotationAnimation(
          asset: 'assets/images/elements/day_sunny2.png',
          animation: animation,
          clockwise: true,
        ),
        Image.asset('assets/images/elements/day_sunny3.png'),
        rotationAnimation(
          asset: 'assets/images/elements/day_sunny4.png',
          animation: animation,
          clockwise: false,
        ),
        Image.asset('assets/images/elements/day_sunny5.png'),
        rotationAnimation(
          asset: 'assets/images/elements/day_sunny6.png',
          animation: animation,
          clockwise: true,
        ),
        Image.asset('assets/images/elements/day_sunny7.png'),
      ],
    );
  }

  Widget nightSunnyAnimationBackContent(List<Animation<double>> animation) {
    return Stack(
      children: [
        fadeInOutAnimation(
            asset: 'assets/images/elements/night_sunny2.png',
            animation: animation[0]),
        fadeInOutAnimation(
            asset: 'assets/images/elements/night_sunny3.png',
            animation: animation[1]),
      ],
    );
  }

  // Night Sunny Content
  Widget nightSunnyBlendBackContent(Animation<double> animation) {
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
          print('snapshot.connectionState == ConnectionState.done [실행]');
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
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_cloud1.png',
            animation: animation[3],
            opacity: 1.0),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_cloud4.png',
            animation: animation[2],
            opacity: 1.0),
      ],
    );
  }

  Widget dayCloudAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_cloud2.png',
            animation: animation[0],
            opacity: 0.7),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_cloud3.png',
            animation: animation[1],
            opacity: 1.0),
      ],
    );
  }

  Widget nightCloudAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_cloud1.png',
            animation: animation[3],
            opacity: 0.7),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_cloud4.png',
            animation: animation[2],
            opacity: 0.7),
      ],
    );
  }

  Widget nightCloudAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_cloud2.png',
            animation: animation[0],
            opacity: 0.4),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_cloud3.png',
            animation: animation[1],
            opacity: 0.6),
      ],
    );
  }

  Widget dayMistAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    print('>>>> animation[1].value : [${animation[1].value}]');
    return Stack(
      children: [
        moveWithOpacityAnimation(
            asset: 'assets/images/elements/day_mist1.png',
            animation: animation[1],
            top: 10,
            bottom: 40),
        moveFullScreenAnimation(
            asset: 'assets/images/elements/day_mist2.png',
            animation: animation[0],
            opacity: 1.0,
            top: 0,
            bottom: 40),
        moveWithOpacityAnimation(
            asset: 'assets/images/elements/day_mist3.png',
            animation: animation[2],
            top: 10,
            bottom: 40)
      ],
    );
  }

  Widget dayMistAnimationBackContent(BuildContext context) {
    return Positioned(
      height: 130,
      left: 50,
      bottom: MediaQuery.of(context).size.height * 0.47,
      child: Stack(
        children: [
          Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/elements/day_sunny2.png',
              )),
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              'assets/images/elements/day_sunny3.png',
            ),
          ),
          Opacity(
            opacity: 0.15,
            child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.screen,
                ),
                child: Image.asset('assets/images/elements/day_sunny4.png')),
          ),
        ],
      ),
    );
  }

  Widget dayDrizzleAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final lowHeight = (MediaQuery.of(context).size.height) * 0.55;
    final highHeight = (MediaQuery.of(context).size.height) * 0.45;
    final fullHeight = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        fadeInOutAnimation(
          asset: 'assets/images/elements/drizzle1.png',
          animation: animation[4],
          bottom: 5,
          left: 10,
          right: 10,
        ),
        fadeInOutAnimation(
          asset: 'assets/images/elements/drizzle2.png',
          animation: animation[5],
          bottom: 5,
          left: 10,
          right: 10,
        ),
        fadeInOutAnimation(
          asset: 'assets/images/elements/drizzle3.png',
          animation: animation[4],
          bottom: 50,
          left: 10,
          right: 10,
        ),
        fadeInOutAnimation(
          asset: 'assets/images/elements/drizzle4.png',
          animation: animation[5],
          bottom: 5,
          left: 10,
          right: 10,
        ),
        moveWithOpacityPartAnimation(
            asset: 'assets/images/elements/drizzle_mist1.png',
            animation: animation[2],
            height: fullHeight,
            isFullOpacity: false),
        moveWithOpacityPartAnimation(
            asset: 'assets/images/elements/drizzle_mist2.png',
            animation: animation[3],
            height: fullHeight,
            isFullOpacity: true),
        moveWithOpacityPartAnimation(
            asset: 'assets/images/elements/drizzle_cloud3.png',
            animation: animation[1],
            height: lowHeight,
            isFullOpacity: true),
        moveWithOpacityPartAnimation(
            asset: 'assets/images/elements/drizzle_cloud2.png',
            animation: animation[1],
            height: highHeight,
            isFullOpacity: false)
      ],
    );
  }

  Widget dayDrizzleAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        movePartScreenAnimation(
            asset: 'assets/images/elements/drizzle_cloud1.png',
            animation: animation[0],
            opacity: 0.7),
      ],
    );
  }

  Widget nightDrizzleAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final lowHeight = (MediaQuery.of(context).size.height) * 0.45;
    final highHeight = (MediaQuery.of(context).size.height) * 0.35;
    final fullHeight = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        fadeInOutAnimation(
          asset: 'assets/images/elements/drizzle3.png',
          animation: animation[4],
          bottom: 50,
          left: 10,
          right: 10,
        ),
        moveWithOpacityPartAnimation(
            asset: 'assets/images/elements/drizzle_mist1.png',
            animation: animation[0],
            height: fullHeight,
            isFullOpacity: false),
        moveWithOpacityPartAnimation(
            asset: 'assets/images/elements/drizzle_mist2.png',
            animation: animation[1],
            height: fullHeight,
            isFullOpacity: true),
        moveWithOpacityPartAnimation(
            asset: 'assets/images/elements/drizzle_cloud3.png',
            animation: animation[1],
            height: lowHeight,
            isFullOpacity: true),
      ],
    );
  }

  Widget nightDrizzleAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final highHeight = (MediaQuery.of(context).size.height) * 0.35;
    return Stack(
      children: [
        fadeInOutAnimation(
          asset: 'assets/images/elements/drizzle1.png',
          animation: animation[4],
          bottom: 5,
          left: 10,
          right: 10,
        ),
        fadeInOutAnimation(
          asset: 'assets/images/elements/drizzle2.png',
          animation: animation[5],
          bottom: 5,
          left: 10,
          right: 10,
        ),
        fadeInOutAnimation(
          asset: 'assets/images/elements/drizzle4.png',
          animation: animation[5],
          bottom: 5,
          left: 10,
          right: 10,
        ),
        movePartScreenAnimation(
            asset: 'assets/images/elements/drizzle_cloud1.png',
            animation: animation[0],
            opacity: 0.7),
        moveWithOpacityPartAnimation(
            asset: 'assets/images/elements/drizzle_cloud2.png',
            animation: animation[3],
            height: highHeight,
            isFullOpacity: true)
      ],
    );
  }

  Widget dayAndNightThunderAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    final lowHeight = (MediaQuery.of(context).size.height) * 0.45;
    final highHeight = (MediaQuery.of(context).size.height) * 0.35;
    return Stack(
      children: [
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_thunder1.png',
            animation: animation[0],
            opacity: 1.0,
            height: height * 0.39,
            width: width),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_thunder2.png',
            animation: animation[3],
            opacity: 1.0,
            height: height * 0.35,
            width: width),
        fadeInOutAnimation(
          asset: 'assets/images/elements/day_thunder7.png',
          animation: animation[5],
          top: height * 0.25,
          left: width * 0.5,
          width: width * 0.2,
        ),
        fadeInOutAnimation(
          asset: 'assets/images/elements/day_thunder7.png',
          animation: animation[6],
          top: height * 0.2,
          left: width * 0.6,
          width: width * 0.2,
        ),
        fadeInOutAnimation(
          asset: 'assets/images/elements/day_thunder6.png',
          animation: animation[4],
          top: height * 0.2,
          left: width * 0.25,
          width: width * 0.2,
        ),
        fadeInOutAnimation(
          asset: 'assets/images/elements/day_thunder6.png',
          animation: animation[5],
          top: height * 0.3,
          left: width * 0.3,
          width: width * 0.2,
        ),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_thunder3.png',
            animation: animation[2],
            opacity: 1.0,
            height: height * 0.35,
            width: width),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_thunder3.png',
            animation: animation[1],
            opacity: 1.0,
            height: height * 0.4,
            width: width),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_thunder1.png',
            animation: animation[0],
            opacity: 1.0,
            height: height * 0.5,
            width: width),
      ],
    );
  }

  Widget dayAndNightThunderAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final highHeight = (MediaQuery.of(context).size.height) * 0.35;
    return Stack(
      children: [
        // Todo : Add more images
      ],
    );
  }

  Widget dayRainAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        fadeInOutAnimation(
            asset: 'assets/images/elements/day_rain1.png',
            animation: animation[4],
            width: width,
            bottom: 10),
        fadeInOutAnimation(
            asset: 'assets/images/elements/day_rain2.png',
            animation: animation[5],
            width: width,
            bottom: 10),
        fadeInOutAnimation(
            asset: 'assets/images/elements/day_rain3.png',
            animation: animation[6],
            width: width,
            bottom: 10),
        fadeInOutAnimation(
            asset: 'assets/images/elements/day_rain4.png',
            animation: animation[7],
            width: width,
            bottom: 10),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_rain_cloud1.png',
          animation: animation[0],
          height: height * 0.3,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_rain_cloud1.png',
          animation: animation[1],
          height: height * 0.4,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_rain_cloud2.png',
            animation: animation[3],
            height: height * 0.55,
            width: width,
            opacity: 1.0),
      ],
    );
  }

  Widget dayRainAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_rain_cloud2.png',
          animation: animation[2],
          opacity: 0.7,
          height: height * 0.35,
        ),
      ],
    );
  }

  Widget nightRainAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [],
    );
  }

  Widget nightRainAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        fadeInOutAnimation(
            asset: 'assets/images/elements/night_rain1.png',
            animation: animation[4],
            width: width,
            bottom: 10),
        fadeInOutAnimation(
            asset: 'assets/images/elements/night_rain2.png',
            animation: animation[5],
            width: width,
            bottom: 10),
        fadeInOutAnimation(
            asset: 'assets/images/elements/night_rain3.png',
            animation: animation[6],
            width: width,
            bottom: 10),
        fadeInOutAnimation(
            asset: 'assets/images/elements/night_rain4.png',
            animation: animation[7],
            width: width,
            bottom: 10),
        moveWithOpacityPartAnimation(
          asset: 'assets/images/elements/night_rain_cloud1.png',
          animation: animation[0],
          height: height * 0.3,
          isFullOpacity: false,
        ),
        moveWithOpacityPartAnimation(
          asset: 'assets/images/elements/night_rain_cloud1.png',
          animation: animation[1],
          height: height * 0.4,
          isFullOpacity: true,
        ),
        movePartScreenAnimation(
            asset: 'assets/images/elements/night_rain_cloud3.png',
            animation: animation[3],
            opacity: 1.0,
            height: height * 0.35,
            width: width),
        movePartScreenAnimation(
          asset: 'assets/images/elements/night_rain_cloud4.png',
          animation: animation[2],
          opacity: 0.7,
          height: height * 0.35,
        ),
      ],
    );
  }

  Widget dayShowersAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    final bottom = 50.0;
    return Stack(
      children: [
        fadeInOutAnimation(
            asset: 'assets/images/elements/showers1.png',
            animation: animation[4],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/showers2.png',
            animation: animation[5],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/showers3.png',
            animation: animation[6],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/showers4.png',
            animation: animation[7],
            width: width,
            bottom: bottom),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_rain_cloud1.png',
          animation: animation[0],
          height: height * 0.3,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_rain_cloud1.png',
          animation: animation[1],
          height: height * 0.4,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_rain_cloud2.png',
            animation: animation[3],
            height: height * 0.55,
            width: width,
            opacity: 1.0),
      ],
    );
  }

  Widget dayShowersAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_rain_cloud2.png',
          animation: animation[2],
          opacity: 0.7,
          height: height * 0.35,
        ),
      ],
    );
  }

  Widget nightShowersAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    final bottom = 50.0;
    return Stack(
      children: [
        fadeInOutAnimation(
            asset: 'assets/images/elements/showers1.png',
            animation: animation[4],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/showers2.png',
            animation: animation[5],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/showers3.png',
            animation: animation[6],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/showers4.png',
            animation: animation[7],
            width: width,
            bottom: bottom),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_rain_cloud1.png',
          animation: animation[0],
          height: height * 0.3,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_rain_cloud1.png',
          animation: animation[1],
          height: height * 0.4,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_rain_cloud2.png',
            animation: animation[3],
            height: height * 0.55,
            width: width,
            opacity: 1.0),
      ],
    );
  }

  Widget nightShowersAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_rain_cloud2.png',
          animation: animation[2],
          opacity: 0.7,
          height: height * 0.35,
        ),
      ],
    );
  }

  Widget dayHeavyrainAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    final bottom = 50.0;
    return Stack(
      children: [
        fadeInOutAnimation(
            asset: 'assets/images/elements/heavyrain1.png',
            animation: animation[4],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/heavyrain2.png',
            animation: animation[5],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/heavyrain3.png',
            animation: animation[6],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/heavyrain4.png',
            animation: animation[7],
            width: width,
            bottom: bottom),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_heavyrain_cloud2.png',
          animation: animation[1],
          height: height * 0.4,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
          asset: 'assets/images/elements/night_heavyrain_cloud2.png',
          animation: animation[2],
          height: height * 0.42,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
            asset: 'assets/images/elements/day_heavyrain_cloud3.png',
            animation: animation[3],
            height: height * 0.4,
            width: width,
            opacity: 1.0),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_heavyrain_cloud1.png',
          animation: animation[0],
          height: height * 0.4,
          opacity: 1.0,
        ),
      ],
    );
  }

  Widget dayHeavyrainAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [],
    );
  }

  Widget nightHeavyrainAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    final bottom = 50.0;
    return Stack(
      children: [
        fadeInOutAnimation(
            asset: 'assets/images/elements/heavyrain1.png',
            animation: animation[4],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/heavyrain2.png',
            animation: animation[5],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/heavyrain3.png',
            animation: animation[6],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/heavyrain4.png',
            animation: animation[7],
            width: width,
            bottom: bottom),
        movePartScreenAnimation(
          asset: 'assets/images/elements/night_heavyrain_cloud2.png',
          animation: animation[1],
          height: height * 0.4,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
          asset: 'assets/images/elements/night_heavyrain_cloud2.png',
          animation: animation[2],
          height: height * 0.42,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
            asset: 'assets/images/elements/night_heavyrain_cloud3.png',
            animation: animation[3],
            height: height * 0.4,
            width: width,
            opacity: 1.0),
        movePartScreenAnimation(
          asset: 'assets/images/elements/night_heavyrain_cloud1.png',
          animation: animation[0],
          height: height * 0.4,
          opacity: 1.0,
        ),
      ],
    );
  }

  Widget nightHeavyrainAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
      ],
    );
  }

  Widget dayBlizzardAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    final bottom = 100.0;
    return Stack(
      children: [
        fadeInOutAnimation(
            asset: 'assets/images/elements/blizzard1.png',
            animation: animation[2],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/blizzard2.png',
            animation: animation[3],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/blizzard1.png',
            animation: animation[4],
            width: width,
            bottom: bottom),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_blizzard_cloud1.png',
          animation: animation[0],
          height: height * 0.35,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
          asset: 'assets/images/elements/day_blizzard_cloud2.png',
          animation: animation[1],
          height: height * 0.35,
          opacity: 1.0,
        ),
      ],
    );
  }

  Widget dayBlizzardAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [],
    );
  }

  Widget nightBlizzardAnimationFrontContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;
    final bottom = 100.0;
    return Stack(
      children: [
        fadeInOutAnimation(
            asset: 'assets/images/elements/blizzard1.png',
            animation: animation[2],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/blizzard2.png',
            animation: animation[3],
            width: width,
            bottom: bottom),
        fadeInOutAnimation(
            asset: 'assets/images/elements/blizzard1.png',
            animation: animation[4],
            width: width,
            bottom: bottom),
        movePartScreenAnimation(
          asset: 'assets/images/elements/night_blizzard_cloud1.png',
          animation: animation[0],
          height: height * 0.35,
          opacity: 1.0,
        ),
        movePartScreenAnimation(
          asset: 'assets/images/elements/night_blizzard_cloud2.png',
          animation: animation[1],
          height: height * 0.35,
          opacity: 1.0,
        ),
      ],
    );
  }

  Widget nightBlizzardAnimationBackContent(
      BuildContext context, List<Animation<double>> animation) {
    final height = (MediaQuery.of(context).size.height);
    return Stack(
      children: [
      ],
    );
  }
}
