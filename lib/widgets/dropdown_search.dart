import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:steadyroutes/helpers/constants.dart';

class DropDownSearch extends StatelessWidget {
  const DropDownSearch({
    Key? key,
    required this.name,
    required this.savedValue,
    this.onFind,
    this.items,
    this.initialValue,
  }) : super(key: key);

  final String name;
  final ValueChanged<String?> savedValue;
  final Future<List<String>> Function(String)? onFind;
  final List<String>? items;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: DropdownSearch<String>(
        selectedItem: initialValue == '' ? null : initialValue,
        items: items,
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
          labelText: name,
          hintText: 'Choose a $name',
        ),
        searchBoxDecoration: kTextFieldDecoration.copyWith(
          labelText: name,
          hintText: 'Search $name',
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
