import 'package:flutter/material.dart';

Route createSwipeRoute(Widget screen, String direction) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var dx = 0.0;
      var dy = 0.0;

      switch (direction) {
        case 'up':
          dy = 1.0;
          break;
        case 'down':
          dy = -1.0;
          break;
        case 'left':
          dx = -1.0;
          break;
        case 'right':
          dx = 1.0;
          break;
        default:
          break;
      }

      var begin = Offset(dx, dy);
      var end = Offset.zero;
      var curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.decelerate));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 450), // 전환 효과 지속 시간 조절
  );
}

Route createOntapRoute(Widget screen, String name) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        // position: offsetAnimation,
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 500), // 전환 지속 시간 설정
  );
}