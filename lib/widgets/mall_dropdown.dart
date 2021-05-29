import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';

class MallDropdown extends StatelessWidget {
  final ValueChanged<String?> onChange;

  const MallDropdown(this.onChange);
  @override
  Widget build(BuildContext context) {
    final List<String> mallData = ['Mall1', 'Mall2'];
    return DropdownSearch<String>(
      showAsSuffixIcons: true,
      searchBoxDecoration: kTextFieldDecoration.copyWith(
        labelText: 'Mall Name',
        hintText: 'Search malls',
      ),
      dropdownSearchDecoration: kTextFieldDecoration.copyWith(
        labelText: 'Mall Name',
        hintText: 'Choose a mall',
      ),
      onChanged: (val) => onChange(val),
      showClearButton: true,
      mode: Mode.BOTTOM_SHEET,
      showSearchBox: true,
      items: mallData,
      validator: (value) {
        if (value == null) {
          return 'You Need To Select A Mall';
        } else {
          return null;
        }
      },
    );
  }
}
