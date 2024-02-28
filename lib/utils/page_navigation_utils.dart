import 'package:flutter/material.dart';
import 'package:morning_weather/utils/screen_navigation_utils.dart';
import 'package:realm/realm.dart';

import '../models/location.dart';
import '../services/location_data_service.dart';

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

/*
void handleHorizontalSwipe(
    {required DragUpdateDetails details,
    required BuildContext context,
    required bool isDragging,
    required bool isLoading,
    required int currentIndex,
    required int pageLength,
    required PageController pageController}) {

  const double sensitivity = 20.0;

  final bool isSwipeRight = details.delta.dx > sensitivity;
  final bool isSwipeLeft = details.delta.dx < -sensitivity;
  if ((isSwipeRight || isSwipeLeft) && !isDragging && !isLoading) {
    // Todo Navigate To AddScreen
    print('>>> currentIndex: $currentIndex');
    print('>>> pageLength: $pageLength');

    if (currentIndex == pageLength - 1 && isSwipeLeft) {
      print('Navigate To AddScreen');
      navigateToNewScreen(context, true, (value) {
        if (value) {
          final newConfig = Configuration.local([Location.schema]);
          final newRealm = Realm(newConfig);
          final newLocationData = LocationDataService(newRealm);
          final newLocations = newLocationData.fetchLocations();
          setState(() {
            _updateLocationAndWeatherData(newLocations.last);
            pageLength = newLocations.length;
            currentIndex = pageLength - 1;
            pageController.animateToPage(
              currentIndex,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        }
      });
    } else if (currentIndex == 0 && isSwipeRight) {
      // Todo Navigate To IntroduceScreen
      print('IntroduceScreen');
      navigateToNewScreen(context, false, (value) => () {});
    } else {
      navigateToPage(pageController, pageLength, isSwipeLeft);
    }
    isDragging = true;
    isLoading = true;
  }
}
*/