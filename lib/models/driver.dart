import 'package:flutter/foundation.dart';

class Driver {
  final int /*!*/ id;
  final String /*!*/ name;
  final String /*!*/ username;
  final String /*!*/ plateNumber;
  final int /*!*/ drivingLicense;
  final String /*!*/ drivingLicenseExDate; //*may require change
  final String /*!*/ company;
  final String /*!*/ passportNumber;
  final String /*!*/ passportExDate; //*may require change
  final int /*!*/ visaNumber; //*may require change
  final String /*!*/ visaExDate; //*may require change

  Driver({
    @required this.id,
    @required this.name,
    @required this.username,
    @required this.plateNumber,
    @required this.drivingLicense,
    @required this.drivingLicenseExDate,
    @required this.company,
    @required this.passportNumber,
    @required this.passportExDate,
    @required this.visaNumber,
    @required this.visaExDate,
  });
// Driver.fromJson(Map<String, dynamic> json)
  Driver.fromJson(dynamic json)
      : id = int.parse(json['id'].toString()),
        name = json['name'].toString(),
        username = json['username'].toString(),
        plateNumber = json['plateNumber'].toString(),
        drivingLicense = int.parse(json['drivingLicense'].toString()),
        drivingLicenseExDate = json['drivingLicenseExDate'].toString(),
        company = json['company'].toString(),
        passportNumber = json['passportNumber'].toString(),
        passportExDate = json['passportExDate'].toString(),
        visaNumber = int.parse(json['visaNumber'].toString()),
        visaExDate = json['visaExDate'].toString();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['plateNumber'] = plateNumber;
    data['drivingLicense'] = drivingLicense;
    data['drivingLicenseExDate'] = drivingLicenseExDate;
    data['company'] = company;
    data['passportNumber'] = passportNumber;
    data['passportExDate'] = passportExDate;
    data['visaNumber'] = visaNumber;
    data['visaExDate'] = visaExDate;
    return data;
  }

  Driver copyWith({
    int id,
    String name,
    String username,
    String plateNumber,
    int drivingLicense,
    String drivingLicenseExDate, //*may require change
    String company,
    String passportNumber,
    String passportExDate, //*may require change
    int visaNumber, //*may require change
    String visaExDate, //*may require change
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      plateNumber: plateNumber ?? this.plateNumber,
      drivingLicense: drivingLicense ?? this.drivingLicense,
      drivingLicenseExDate: drivingLicenseExDate ?? this.drivingLicenseExDate,
      company: company ?? this.company,
      passportNumber: passportNumber ?? this.passportNumber,
      passportExDate: passportExDate ?? this.passportExDate,
      visaNumber: visaNumber ?? this.visaNumber,
      visaExDate: visaExDate ?? this.visaExDate,
    );
  }
}
