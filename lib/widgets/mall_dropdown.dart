import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/location.dart';
import 'package:steadyroutes/services/steady_api_service.dart';

class MallDropDown extends StatelessWidget {
  const MallDropDown({
    Key? key,
    required this.jwt,
    required this.api,
    required this.savedValue,
  }) : super(key: key);

  final String jwt;
  final SteadyApiService api;
  final ValueChanged<Location?> savedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: DropdownSearch<Location>(
        onFind: (_) async {
          await api.locationsService.fetchLocation(
            jwt,
          );
          return api.locationsService.locations.map(
            (item) {
              return item;
            },
          ).toList();
        },
        itemAsString: (item) => item.address,
        onChanged: (Location? picked) {
          if (picked != null) {
            savedValue(picked);
            // selectedLocation = picked;
          }
        },
        showAsSuffixIcons: true,
        dropdownSearchDecoration: kTextFieldDecoration.copyWith(
          labelText: 'Mall Name',
          hintText: 'Choose a Mall',
        ),
        searchBoxDecoration: kTextFieldDecoration.copyWith(
          labelText: 'Mall Name',
          hintText: 'Search Malls',
        ),
        showClearButton: true,
        validator: (value) {
          if (value == null) {
            return 'Please select a Mall';
          }
          return null;
        },
        showSearchBox: true,
      ),
    );
  }
}
