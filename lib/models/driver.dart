import 'package:steadyroutes/models/courier.dart';
import 'package:steadyroutes/models/user.dart';

class Driver {
  final String? id;
  final String name;
  // final Courier? courier;
  final User? user;
  final int phone;
  final String plateNumber;
  final String drivingLicense;
  final String drivingLicenseExDate; //*may require change
  final String company;
  final String passportNumber;
  final String passportExDate; //*may require change
  final int visaNumber; //*may require change
  final String visaExDate; //*may require change

  Driver({
    this.id,
    required this.name,
    required this.user,
    // required this.courier,
    required this.phone,
    required this.plateNumber,
    required this.drivingLicense,
    required this.drivingLicenseExDate,
    required this.company,
    required this.passportNumber,
    required this.passportExDate,
    required this.visaNumber,
    required this.visaExDate,
    courier,
  });
// Driver.fromJson(Map<String, dynamic> json)
  Driver.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        name = json['name'].toString(),
        user = json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        // courier = json['courier'] == null
        //     ? null
        //     : Courier.fromJson(json['courier'] as Map<String, dynamic>),
        phone = int.tryParse(json['phone'].toString()) ?? 0,
        drivingLicense = json['licenseNo'].toString(),
        plateNumber = json['plateNumber'].toString(),
        drivingLicenseExDate = json['drivingLicenseExDate'].toString(),
        company = json['company'].toString(),
        passportNumber = json['passportNumber'].toString(),
        passportExDate = json['passportExDate'].toString(),
        visaNumber = int.tryParse(json['visaNumber'].toString()) ?? 0,
        visaExDate = json['visaExDate'].toString();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['user'] = user?.toJson();
    // data['courier'] = courier?.toJson();
    data['phone'] = phone;
    data['plateNumber'] = plateNumber;
    data['licenseNo'] = drivingLicense;
    data['drivingLicenseExDate'] = drivingLicenseExDate;
    data['company'] = company;
    data['passportNumber'] = passportNumber;
    data['passportExDate'] = passportExDate;
    data['visaNumber'] = visaNumber;
    data['visaExDate'] = visaExDate;
    return data;
  }

  Driver copyWith({
    String? id,
    String? name,
    int? phone,
    User? user,
    Courier? courier,
    String? plateNumber,
    String? drivingLicense,
    String? drivingLicenseExDate, //*may require change
    String? company,
    String? passportNumber,
    String? passportExDate, //*may require change
    int? visaNumber, //*may require change
    String? visaExDate, //*may require change
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      // courier: courier ?? this.courier,
      phone: phone ?? this.phone,
      user: user ?? this.user,
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
