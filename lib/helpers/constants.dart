import 'package:flutter/material.dart';

//* Could be config file

const String apiBase = 'assets/json/';

const kTextFieldDecoration = InputDecoration(
  labelText: 'Username',
  hintText: 'Enter your username',
  labelStyle: TextStyle(
    color: Colors.black,
  ),
  hintStyle: TextStyle(color: Colors.blueGrey),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

const kTextTitleStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 28,
);

const kErrorScaffoldColor = Color(0xFFB71C1C);
const kDefaultScaffoldColor = Color(0xFF009688);

const kExReportDropDownItems = [
  'Driver Passport',
  'Driver Visa',
  'Driver License',
  'Vehicle Registration',
  'Vehicle RTA License'
];

const kMonthCountDropDownItems = [
  1,
  2,
  3,
];

// [
//   DropdownMenuItem(
//     value: 'Driver Passport',
//     child: Text('Driver Passport'),
//   ),
//   DropdownMenuItem(
//     value: 'Driver Visa',
//     child: Text('Driver Visa'),
//   ),
//   DropdownMenuItem(
//     value: 'Driver License',
//     child: Text('Driver License'),
//   ),
//   DropdownMenuItem(
//     value: 'Vehicle Registration',
//     child: Text('Vehicle Registration'),
//   ),
//   DropdownMenuItem(
//     value: 'Vehicle RTA License',
//     child: Text('Vehicle RTA License'),
//   ),
// ];

const kCompressedImageQuality = 20;
