import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:steadyroutes/helpers/constants.dart';

class DropDownSearch extends StatelessWidget {
  const DropDownSearch(
      {Key? key,
      required this.jwt,
      required this.courierId,
      required this.name,
      required this.savedValue,
      required this.onFind})
      : super(key: key);

  final String jwt;
  final String courierId;
  final String name;
  final ValueChanged<String?> savedValue;
  final Future<List<String>> Function(String)? onFind;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      child: DropdownSearch<String>(
        onFind: onFind,
        onChanged: (String? picked) {
          if (picked != null) {
            savedValue(
              picked,
            );
          }
        },
        showAsSuffixIcons: true,
        dropdownSearchDecoration: kTextFieldDecoration.copyWith(
          labelText: '$name Name',
          hintText: 'Choose a $name',
        ),
        searchBoxDecoration: kTextFieldDecoration.copyWith(
          labelText: '$name Name',
          hintText: 'Search ${name}s',
        ),
        showClearButton: true,
        validator: (value) {
          if (value == null) {
            return 'Please select a $name';
          }
          return null;
        },
        showSearchBox: true,
      ),
    );
  }
}
