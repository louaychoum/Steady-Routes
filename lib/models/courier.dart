import 'package:steadyroutes/models/location.dart';
import 'package:steadyroutes/models/user.dart';

class Courier {
  final String? id;
  final String name;
  final int? phone;
  final User? user;
  final Location? location;

  Courier({
    this.id,
    required this.name,
    required this.phone,
    required this.user,
    required this.location,
  });

  Courier.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        name = json['name'].toString(),
        phone = json['phone'] == null ? 0 : json['phone'] as int,
        user = json['user'] == null
            ? null
            : User.fromJson(
                json['user'] as Map<String, dynamic>,
              ),
        location = json['location'] == null
            ? null
            : Location.fromJson(
                json['location'] as Map<String, dynamic>,
              );

  Courier.fromJsonLogin(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        name = json['name'].toString(),
        phone = json['phone'] == null ? 0 : json['phone'] as int,
        user = json['user'] == null
            ? null
            : User.fromJsonLogin(
                json['user'].toString(),
              ),
        location = json['location'] == null
            ? null
            : Location.fromJsonLogin(
                json['location'].toString(),
              );

  Courier.fromJsonLoginId(String json)
      : id = json.toString(),
        name = '',
        phone = 0,
        location = null,
        user = null;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'phone': phone,
        'user': user,
        'location': location,
      };

  Courier copyWith({
    String? id,
    String? name,
    int? phone,
    User? user,
    Location? location,
    //String? zoneId,
  }) {
    return Courier(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      user: user ?? this.user,
      location: location ?? this.location,
      //zoneId: zoneId ?? this.zoneId,
    );
  }
}
