import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//* Could be config file

const String apiBase = 'assets/json/';

const kTextFieldDecoration = InputDecoration(
  labelText: '',
  hintText: '',
  alignLabelWithHint: true,
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
  hintStyle: TextStyle(
    color: Color(0xFF607D8B),
  ),
  labelStyle: TextStyle(
    color: Color(0xFF000000),
  ),
);

const kTextTitleStyle = TextStyle(
  color: Color(0xff000000),
  fontWeight: FontWeight.bold,
  fontSize: 28,
  letterSpacing: 1,
);

final BaseOptions options = BaseOptions(
  baseUrl: 'https://dropshoptest.herokuapp.com',
  sendTimeout: 30000,
  connectTimeout: 30000,
  receiveTimeout: 30000,
);

const kErrorScaffoldColor = Color(0xFFB71C1C);
const kDefaultScaffoldColor = Color(0xFF009688);

const kExReportDropDownItems = [
  'drivinglicense',
  'visa',
  'passport',
  'Vehicle Registration',
  'Vehicle RTA License'
];
const kMonthCountDropDownItems = [
  1,
  2,
  3,
];
const kVehicleCategoryDropDownItems = [
  'Truck',
  'Bike',
  'Sedan',
];
const kVehicleStatusDropDownItems = [
  'In Operation',
  'In Repair',
  'In Service',
  'End Of Life',
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
