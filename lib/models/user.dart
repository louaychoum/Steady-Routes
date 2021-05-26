enum Access {
  admin,
  driver,
}

class User {
  String username;
  String password;
  String access;
  String jwt;

  User();
// User.fromJson(Map<String, String> json)
  User.fromJson(Map<String, dynamic> json)
      : username = json['username'].toString() ?? "",
        password = json['password'].toString() ?? "",
        jwt = json['jwt'].toString() ?? "",
        access = json['access'].toString() ?? "";
  // Access.values.firstWhere(
  //     (s) => s.toString() == 'Access.${json['access']}',
  //     orElse: () => null);

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'jwt': jwt,
        'access': access,
      };
}
