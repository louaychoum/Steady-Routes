import 'package:steadyroutes/models/courier.dart';

enum Access {
  admin,
  driver,
}

class User {
  final String userId;
  final String email;
  final String password;
  final String role;
  Courier? courier;
  String token;

  User(
      {required this.userId,
      required this.email,
      required this.password,
      required this.role,
      required this.courier,
      required this.token});
// User.fromJson(Map<String, String> json)
  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return User(
          userId: '',
          email: '',
          password: '',
          role: '',
          courier: null,
          token: '');
    }

    return User(
      userId: json['_id'].toString(),
      email: json['email'].toString(),
      password: json['password'].toString(),
      role: json['role'].toString(),
      courier: json['courier'] == null
          ? null
          : Courier.fromJsonLogin(json['courier'] as Map<String, dynamic>),
      token: json['token'].toString(),
    );
  }

  User.fromJsonLogin(String json)
      : userId = json.toString(),
        email = '',
        password = '',
        role = '',
        token = '';

  // Access.values.firstWhere(
  //     (s) => s.toString() == 'Access.${json['access']}',
  //     orElse: () => null);
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'role': role,
        '_id': userId,
        'courier': courier?.toJson(),
        'token': token,
      };
}
