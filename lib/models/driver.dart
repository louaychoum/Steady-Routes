import 'package:steadyroutes/models/user.dart';

class Driver {
  final String? id;
  final String name;
  final int? phone;
  final String licenseNo;
  final String vehicleId;
  final String? zoneId;//todo add in new driver page
  final String? courierId;//todo add in new driver page
  final String licenseExpiryDate; //*may require change
  final String passportNumber;
  final String passportExDate; //*may require change
  final String? visaNumber; //*may require change
  final String visaExDate; //*may require change
  final String? email;
  final String? password;
  final User? user;

  Driver({
    this.id,
    required this.name,
    required this.user,
    required this.email,
    required this.password,
    required this.courierId,
    required this.phone,
    required this.vehicleId,
    required this.licenseNo,
    required this.licenseExpiryDate,
    required this.passportNumber,
    required this.passportExDate,
    required this.visaNumber,
    required this.visaExDate,
    required this.zoneId,
  });

// Driver.fromJson(Map<String, dynamic> json)
  Driver.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        name = json['name'].toString(),
        email = json['email'].toString(),
        password = json['password'].toString(),
        user = json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        courierId = json['courierId'].toString(),
        phone = int.tryParse(json['phone'].toString()) ?? 0,
        licenseNo = json['licenseNo'].toString(),
        vehicleId = json['vehicleId'].toString(),
        zoneId = json['zoneId'].toString(),
        licenseExpiryDate = json['licenseExpiryDate'].toString(),
        passportNumber = json['passportNumber'].toString(),
        passportExDate = json['passportExpiryDate'].toString(),
        visaNumber = json['visaNumber'].toString(),
        visaExDate = json['visaExpiryDate'].toString();

  Driver.fromJsonLogin(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        name = json['name'].toString(),
        email = json['email'].toString(),
        password = json['password'].toString(),
        user = json['user'] == null
            ? null
            : User.fromJsonLogin(
                json['user'].toString(),
              ),
        courierId = json['courierId'].toString(),
        phone = int.tryParse(json['phone'].toString()) ?? 0,
        licenseNo = json['licenseNo'].toString(),
        vehicleId = json['vehicleId'].toString(),
        zoneId = json['zoneId'].toString(),
        licenseExpiryDate = json['licenseExpiryDate'].toString(),
        passportNumber = json['passportNumber'].toString(),
        passportExDate = json['passportExpiryDate'].toString(),
        visaNumber = json['visaNumber'].toString(),
        visaExDate = json['visaExpiryDate'].toString();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['user'] = user?.toJson();
    data['email'] = email;
    data['password'] = password;
    data['courierId'] = courierId;
    data['phone'] = phone;
    data['vehicleId'] = vehicleId;
    data['zoneId'] = zoneId;
    data['licenseNo'] = licenseNo;
    data['licenseExpiryDate'] = licenseExpiryDate;
    data['passportNumber'] = passportNumber;
    data['passportExpiryDate'] = passportExDate;
    data['visaNumber'] = visaNumber;
    data['visaExpiryDate'] = visaExDate;
    return data;
  }

  Driver copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    int? phone,
    User? user,
    String? courierId,
    String? zoneId,
    String? vehicleId,
    String? licenseNo,
    String? licenseExpiryDate, //*may require change
    String? passportNumber,
    String? passportExDate, //*may require change
    String? visaNumber, //*may require change
    String? visaExDate, //*may require change
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      courierId: courierId ?? this.courierId,
      phone: phone ?? this.phone,
      user: user ?? this.user,
      vehicleId: vehicleId ?? this.vehicleId,
      zoneId: zoneId ?? this.zoneId,
      licenseNo: licenseNo ?? this.licenseNo,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      passportNumber: passportNumber ?? this.passportNumber,
      passportExDate: passportExDate ?? this.passportExDate,
      visaNumber: visaNumber ?? this.visaNumber,
      visaExDate: visaExDate ?? this.visaExDate,
    );
  }
}
