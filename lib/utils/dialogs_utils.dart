import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialog {
  static Future<bool?> showConfirmDialog(BuildContext context, String city) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add New Weather',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                children: [
                  TextSpan(text: 'Would you like to add\n[ '),
                  TextSpan(
                      text: '${city}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' ]\'s\n weather?'),
                ]),
          ),
          actions: <Widget>[
            _createDialogButton(
                context, 'Cancel', () => Navigator.of(context).pop(false)),
            _createDialogButton(
                context, 'OK', () => Navigator.of(context).pop(true)),
          ],
        );
      },
    );
  }

  static Future<void> showImputMissingValidateDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Input Missing',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Please enter the region whose weather you want to know',
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            _createDialogButton(
                context, 'OK', () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  static Future<void> showLocationLimitDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Maximum region exceeded',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'You can check up to a maximum of 3 regions, including your current location.',
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            _createDialogButton(
                context, 'OK', () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  static Widget _createDialogButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}