import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_utils.dart';

class Dialog {
  static Future<bool?> showConfirmDialog(
      BuildContext context, String city, bool isLightMode) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: isLightMode ? Color(0xFFFFFFFF) : Color(0xFF343438),
          title: Text(
            'Add New Weather',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF)),
            textAlign: TextAlign.center,
          ),
          content: _createContent(
              isLightMode, 'Would you like to add [$city]\'s weather?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _createDialogButton(
                    context, 'Cancel', () => Navigator.of(context).pop(false)),
                rowSpace(1.0),
                _createDialogButton(
                    context, 'OK', () => Navigator.of(context).pop(true)),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<void> showInputMissingValidateDialog(
      BuildContext context, bool isLightMode) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: isLightMode ? Color(0xFFFFFFFF) : Color(0xFF343438),
          title: Text(
            'Input Missing',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF),
            ),
            textAlign: TextAlign.center,
          ),
          content: _createContent(isLightMode,
              'Please enter the region whose weather you want to know'),
          actions: <Widget>[
            _createDialogButton(
                context, 'OK', () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  static Future<void> showLocationLimitDialog(
      BuildContext context, bool isLightMode) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: isLightMode ? Color(0xFFFFFFFF) : Color(0xFF343438),
          title: Text(
            'Maximum region exceeded',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF),
            ),
            textAlign: TextAlign.center,
          ),
          content: _createContent(isLightMode,
              'You can check up to a maximum of 3 regions, including your current location.'),
          actions: <Widget>[
            _createDialogButton(
                context, 'OK', () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  static Widget _createContent(bool isLightMode, String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        getAssetImage('images/wini/day_sunny.png', 36.0, 36.0, null),
        Text(
          message,
          style: TextStyle(
            fontSize: 20.0,
            color: isLightMode ? Color(0xFF57585E) : Color(0xFFFFFFFF),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static Widget _createDialogButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: Color(0xFFEF3B08),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: Color(0xFFEF3B08), fontWeight: FontWeight.bold),
      ),
    );
  }
}
