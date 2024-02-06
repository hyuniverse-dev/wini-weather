import 'package:flutter/cupertino.dart';
import 'package:morning_weather/screens/settings_screen.dart';
import 'package:morning_weather/widgets/home_screen/custom_route.dart';

import '../screens/add_location_screen.dart';
import '../screens/introduce_screen.dart';

/// 이 함수는 [controller], [pageLength], [isNextPage]를 매개변수로 받아 페이지 컨트롤러의 이전 페이지 또는 다음 페이지로 이동합니다.
void navigateToPage(
    PageController controller, int pageLength, bool isNextPage) {
  if (isNextPage) {
    if (controller.page!.round() < pageLength - 1) {
      controller.nextPage(
          duration: Duration(milliseconds: 600), curve: Curves.easeOut);
    }
  } else {
    if (controller.page!.round() > 0) {
      controller.previousPage(
          duration: Duration(milliseconds: 600), curve: Curves.easeOut);
    }
  }
}

/// 이 함수는 [context], [isNext], [postNavigation]을 매개변수로 받아 새로운 화면으로 네비게이션 합니다.
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
