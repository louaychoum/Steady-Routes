import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//* Could be config file

const String apiBase = 'assets/json/';

const kTextFieldDecoration = InputDecoration(
  labelText: '',
  hintText: '',
);

const kTextTitleStyle = TextStyle(
  color: Color(0xff000000),
  fontWeight: FontWeight.bold,
  fontSize: 28,
  letterSpacing: 1,
);

final BaseOptions options = BaseOptions(
  baseUrl: 'https://dropshoptest.herokuapp.com',
  connectTimeout: 10000,
  receiveTimeout: 10000,
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
