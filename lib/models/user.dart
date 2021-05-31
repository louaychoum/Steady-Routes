enum Access {
  admin,
  driver,
}

class User {
  final String userId;
  final String email;
  final String password;
  final String role;
  String token;

  User(
      {required this.userId,
      required this.email,
      required this.password,
      required this.role,
      required this.token});
// User.fromJson(Map<String, String> json)
  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return User(userId: '', email: '', password: '', role: '', token: '');
    }

    return User(
      userId: json['_id'].toString(),
      email: json['email'].toString(),
      password: json['password'].toString(),
      role: json['role'].toString(),
      token: json['token'].toString(),
    );
  }

  // Access.values.firstWhere(
  //     (s) => s.toString() == 'Access.${json['access']}',
  //     orElse: () => null);
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'role': role,
        '_id': userId,
        'token': token,
      };
}
