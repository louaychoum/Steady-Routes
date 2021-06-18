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
      driverId: json['driver'].toString(),
      locationId: json['location'].toString(),
      vehicleId: json['vehicle'].toString(),
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

  Map<String, dynamic> toJson() => {
        '_id': id,
        'driver': driverId,
        'location': locationId,
        'vehicle': vehicleId,
        'date': date,
        'action': action,
        'latitude': latitude,
        'longitude': longitude,
      };
}
