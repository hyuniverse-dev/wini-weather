import 'package:flutter/material.dart';

import '../screens/add_location_screen.dart';
import '../screens/introduce_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/home_screen/custom_route.dart';

void navigateToNewScreen(
    BuildContext context, bool isNext, Function(dynamic value) postNavigation) {
  Navigator.of(context)
      .push(createSwipeRoute(isNext ? AddLocationScreen() : IntroduceScreen(),
      isNext ? 'right' : 'left'))
      .then((value) => postNavigation(value));
}

void navigateToSettingsScreen(BuildContext context) {
  print('SettingsScreen Button Click!');
  Navigator.of(context).push(
    createOntapRoute(SettingsScreen(), 'settingsScreen'),
  );
}
