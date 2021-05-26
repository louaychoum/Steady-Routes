import 'package:flutter/foundation.dart';

class Vehicle {
  final int id;
  final String name;
  final String plateNumber;
  final String registrationExDate;
  final int rtaNumber;
  final String rtaExDate;

  Vehicle({
    @required this.id,
    @required this.name,
    @required this.plateNumber,
    @required this.registrationExDate,
    @required this.rtaNumber,
    @required this.rtaExDate,
  });

  Vehicle.fromJson(dynamic json)
      : id = int.parse(json['id'].toString()),
        name = json['name'].toString(),
        plateNumber = json['plateNumber'].toString(),
        registrationExDate = json['registrationExDate'].toString(),
        rtaNumber = int.parse(json['rtaNumber'].toString()),
        rtaExDate = json['rtaExDate'].toString();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['plateNumber'] = plateNumber;
    data['registrationExDate'] = registrationExDate;
    data['rtaNumber'] = rtaNumber;
    data['rtaExDate'] = rtaExDate;
    return data;
  }

  Vehicle copyWith({
    int id,
    String name,
    String plateNumber,
    String registrationExDate,
    int rtaNumber,
    String rtaExDate,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      registrationExDate: registrationExDate ?? this.registrationExDate,
      rtaNumber: rtaNumber ?? this.rtaNumber,
      rtaExDate: rtaExDate ?? this.rtaExDate,
    );
  }
}
