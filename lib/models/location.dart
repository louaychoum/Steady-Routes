class Location {
  final String id;
  final String address;
  final String latitude;
  final String longitude;

  Location({
    required this.id,
    required this.address,
    this.latitude = '',
    this.longitude = '',
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
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      };
}
