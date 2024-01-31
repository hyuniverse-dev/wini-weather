import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarGraphBuilder extends StatelessWidget {
  final double values;

  const BarGraphBuilder({
    super.key,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBar(value: values);
  }
}

class AnimatedBar extends StatefulWidget {
  final double value;

  const AnimatedBar({
    super.key,
    required this.value,
  });

  @override
  State<AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<AnimatedBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightFactorAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _heightFactorAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heightFactorAnimation,
      builder: (context, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: _heightFactorAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: 10,
        height: widget.value,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
