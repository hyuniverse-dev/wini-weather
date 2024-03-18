import 'package:flutter/material.dart';

import '../screens/add_location_screen.dart';
import '../screens/introduce_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/home_screen/custom_route.dart';

void navigateToNewScreen(
    {required BuildContext context,
    required bool isLightMode,
    required bool isNext,
    required Function(dynamic value) postNavigation}) async {
  final result = await Navigator.of(context).push(createSwipeRoute(
      isNext
          ? AddLocationScreen(isLightMode: isLightMode)
          : IntroduceScreen(isLightMode: isLightMode),
      isNext ? 'right' : 'left'));
  postNavigation(result);
  print('>>> result: $result');
}

void navigateToSettingsScreen(
    {required BuildContext context, required bool isLightMode}) {
  Navigator.of(context).push(
    createOntapRoute(
        SettingsScreen(isLightMode: isLightMode), 'settingsScreen'),
  );
}
