import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<ui.Image> loadImage(String assetPath) async {
  final completer = Completer<ui.Image>();
  final byteData = await rootBundle.load(assetPath);
  final image = await decodeImageFromList(byteData.buffer.asUint8List());
  completer.complete(image);
  return completer.future;
}

class ImagePainterService extends CustomPainter {
  final ui.Image image1;
  final ui.Image image2;
  final Animation<double> animation;

  ImagePainterService({
    required this.image1,
    required this.image2,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final double pointX = size.width * 0.2;
    final double pointY = size.height * 0.2;
    final double width = 120.0;
    final double height = 120.0;
    final Rect imageRect = Rect.fromLTWH(pointX, pointY, width, height);

    paintImage(
      canvas: canvas,
      rect: imageRect,
      image: image1,
      fit: BoxFit.cover,
    );

    Paint blendImage = Paint()
      ..color = Colors.white.withOpacity(animation.value)
      ..blendMode = BlendMode.screen;

    Paint blendResultImage = Paint()
      ..color = Colors.white.withOpacity((animation.value) * 0.3)
      ..blendMode = BlendMode.plus;

    canvas.drawImageRect(
      image2,
      Rect.fromLTWH(0, 0, image2.width.toDouble(), image2.height.toDouble()),
      imageRect,
      blendResultImage,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

