import 'package:flutter/material.dart';

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
