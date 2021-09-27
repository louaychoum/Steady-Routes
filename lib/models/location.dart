class Location {
  final String id;
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.id,
    required this.address,
    this.latitude = 0,
    this.longitude = 0,
  });
// User.fromJson(Map<String, String> json)
  factory Location.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Location(
        id: '',
        address: '',
      );
    }

    return Location(
      id: json['_id'].toString(),
      address: json['address'].toString(),
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

  Location.fromJsonLogin(String json)
      : id = json.toString(),
        address = '',
        latitude = 0,
        longitude = 0;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      };
}
