import 'package:intl/intl.dart';
import 'package:steadyroutes/helpers/constants.dart';

class Vehicle {
  final String? id;
  final String courierId;
  final String name;
  final String plateNumber;
  final String category;
  final String status;
  final DateTime registrationExDate;
  final String rtaNumber;
  final DateTime rtaExDate;

  Vehicle({
    this.id,
    required this.name,
    required this.courierId,
    required this.plateNumber,
    required this.category,
    required this.status,
    required this.registrationExDate,
    required this.rtaNumber,
    required this.rtaExDate,
  });

  Vehicle.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        name = json['name'].toString(),
        courierId = json['courier'].toString(),
        plateNumber = json['plate'].toString(),
        category = json['category'].toString(),
        status = json['status'].toString(),
        registrationExDate = dateFormat
            .parse(
              json['registrationExpiryDate'].toString(),
            )
            .toLocal(),
        rtaNumber = json['licenseNo'].toString(),
        rtaExDate = dateFormat
            .parse(
              json['licenseExpiryDate'].toString(),
            )
            .toLocal();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['category'] = category;
    data['status'] = status;
    data['plate'] = plateNumber;
    data['registrationExpiryDate'] = registrationExDate;
    data['licenseNo'] = rtaNumber;
    data['licenseExpiryDate'] = rtaExDate;
    data['courier'] = courierId;
    return data;
  }

  Vehicle copyWith({
    String? id,
    String? name,
    String? plateNumber,
    String? courierId,
    String? category,
    String? status,
    DateTime? registrationExDate,
    String? rtaNumber,
    DateTime? rtaExDate,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      courierId: courierId ?? this.courierId,
      plateNumber: plateNumber ?? this.plateNumber,
      category: category ?? this.category,
      status: status ?? this.status,
      registrationExDate: registrationExDate ?? this.registrationExDate,
      rtaNumber: rtaNumber ?? this.rtaNumber,
      rtaExDate: rtaExDate ?? this.rtaExDate,
    );
  }
}
