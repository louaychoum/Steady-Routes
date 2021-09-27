import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//* Could be config file

const kCompressedImageQuality = 20;

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

DateFormat dateFormat = DateFormat("yyyy-MM-dd");

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
  'registration',
  'license',
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
