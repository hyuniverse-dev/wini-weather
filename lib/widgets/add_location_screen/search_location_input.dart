import 'package:flutter/material.dart';
import 'package:mncf_weather/services/location_api_service.dart';
import 'package:mncf_weather/utils/location_utils.dart';
import 'package:realm/realm.dart';
import 'package:mncf_weather/utils/dialogs_utils.dart' as dialogs;

import '../../models/location.dart';

class SearchLocationInput extends StatelessWidget {
  final TextEditingController textController;
  final Configuration config;
  final int locationCount;
  final Color backgroundColor;
  final Color textFieldColor;
  final Color textColor;
  final bool isLightMode;

  // final Function onLocationAdded;

  const SearchLocationInput({
    super.key,
    required this.textController,
    required this.config,
    required this.locationCount,
    required this.backgroundColor,
    required this.textColor,
    required this.textFieldColor,
    required this.isLightMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: textFieldColor,
        borderRadius: BorderRadius.circular(0),
        border: Border(
          bottom: BorderSide(
            color: textColor,
            width: 2.0,
          ),
        ),
      ),
      child: TextField(
        cursorColor: textColor,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        controller: textController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10),
            filled: true,
            fillColor: textFieldColor,
            labelStyle: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
            hintText: 'Region and city names',
            hintStyle: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: textColor,
            ),
            suffixIcon: IconButton(
              color: textColor,
              icon: Icon(Icons.keyboard_return_rounded),
              onPressed: () => _handleSearch(context),
            )),
        onSubmitted: (String value) {
          _handleSearch(context);
        },
      ),
    );
  }

  Future<void> _handleSearch(BuildContext context) async {
    final inputValue = textController.text;
    Realm realm;
    if (inputValue.isEmpty) {
      dialogs.Dialog.showInputMissingValidateDialog(context, isLightMode);
    } else if (locationCount > 2) {
      dialogs.Dialog.showLocationLimitDialog(context, isLightMode);
    } else {
      final locationData = await fetchLocationData(inputValue);
      if (locationData != null) {
        var extractData = await extractLocationData(locationData);
        if (extractData != null) {
          var city = extractData['city'] ?? 'Unknown City';
          final isOk = await dialogs.Dialog.showConfirmDialog(
              context, city!, isLightMode);
          print('locationData.nameDetails.officialNameEn >>> ${locationData.nameDetails.officialNameEn}');
          if (isOk == true) {
            // Create Local Database
            realm = Realm(config);
            realm.write(() {
              realm.add(
                Location(
                  getLastPrimaryKey(realm),
                  locationData.licence,
                  locationData.latitude,
                  locationData.longitude,
                  locationData.nameDetails.officialNameEn ??
                      locationData.address.city!,
                  locationData.address.city ?? locationData.name,
                  locationData.address.country,
                ),
              );
            });
            Navigator.pop(context, true);
            textController.clear();
          } else if (isOk == false) {
            textController.clear();
          }
        } else {
          print('No data extracted.');
        }
      } else {
        print('Location data not found');
      }
    }
  }
}
