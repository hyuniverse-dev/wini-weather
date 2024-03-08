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

  // final Function onLocationAdded;

  const SearchLocationInput({
    super.key,
    required this.textController,
    required this.config,
    required this.locationCount,
    // required this.onLocationAdded,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          hintText: 'Region and city names',
          suffixIcon: IconButton(
            icon: Icon(Icons.keyboard_return_rounded),
            onPressed: () => _handleSearch(context),
          )),
      onSubmitted: (String value) {
        _handleSearch(context);
      },
    );
  }

  Future<void> _handleSearch(BuildContext context) async {
    final inputValue = textController.text;
    Realm realm;
    if (inputValue.isEmpty) {
      dialogs.Dialog.showImputMissingValidateDialog(context);
    } else if (locationCount > 2) {
      dialogs.Dialog.showLocationLimitDialog(context);
    } else {
      final locationData = await fetchLocationData(inputValue);
      if (locationData != null) {
        var extractData = await extractLocationData(locationData);
        if (extractData != null) {
          var city = extractData['city'] ?? 'Unknown City';
          final isOk =
              // await showConfirmDialog(context, city!);
              await dialogs.Dialog.showConfirmDialog(context, city!);
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
