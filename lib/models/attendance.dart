class Attendance {
  final String? id;
  final String driverId;
  final String locationId;
  final String? vehicleId;
  final String date;
  final String action;
  final double latitude;
  final double longitude;

  Attendance({
    this.id,
    required this.driverId,
    required this.locationId,
    this.vehicleId,
    required this.date,
    required this.action,
    required this.latitude,
    required this.longitude,
  });
// User.fromJson(Map<String, String> json)
  factory Attendance.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Attendance(
        id: '',
        driverId: '',
        locationId: '',
        vehicleId: '',
        date: '',
        action: '',
        latitude: 0,
        longitude: 0,
      );
    }

    return Attendance(
      id: json['_id'].toString(),
      driverId: json['driverId'].toString(),
      locationId: json['locationId'].toString(),
      vehicleId: json['vehicleId'].toString(),
      date: json['date'].toString(),
      action: json['action'].toString(),
      latitude: double.tryParse(
            json['latitude'].toString(),
          ) ??
          0,
      longitude: double.tryParse(
            json['longitude'].toString(),
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['driverId'] = driverId;
    data['locationId'] = locationId;
    data['vehicleId'] = vehicleId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['date'] = date;
    data['action'] = action;
    return data;
  }
}
