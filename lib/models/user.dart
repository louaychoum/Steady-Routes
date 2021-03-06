enum Access {
  admin,
  driver,
}

class User {
  final String userId;
  final String username;
  final String password;
  final String access;

  const User({
    required this.userId,
    required this.username,
    required this.password,
    required this.access,
  });
// User.fromJson(Map<String, String> json)
  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const User(userId: '', username: '', password: '', access: '');
    }

    return User(
      userId: json['userId'].toString(),
      username: json['username'].toString(),
      password: json['password'].toString(),
      access: json['access'].toString(),
    );
  }

  // Access.values.firstWhere(
  //     (s) => s.toString() == 'Access.${json['access']}',
  //     orElse: () => null);
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'access': access,
        'userId': userId,
      };
}
