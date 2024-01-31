import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context, String city) {
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
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        );
      });
}

Future<void> showValidateDialog(BuildContext context, String city) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Input Missing',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please enter the region whose weather you want to know',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.black12,
                        width: 1.0,
                      )
                    )
                  ),
                  child: TextButton(
                    child: Text('OK'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      });
}
