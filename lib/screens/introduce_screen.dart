import 'package:flutter/material.dart';

class IntroduceScreen extends StatelessWidget {
  final int sensitivity = 25;

  const IntroduceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Todo fix bug
        print(details.delta.dx);
        // Swipe left
        if (details.delta.dx < -sensitivity) {
          print(details.delta.dx);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Branded App by',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'MNCF.io',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/mncf_logo.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(
                  height: 30,
                ),
                Text('Description about MNCF.io'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
