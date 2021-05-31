import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:steadyroutes/models/user.dart';

enum AuthStatus {
  notDetermined,
  notLoggedIn,
  adminLoggedIn,
  driverLoggedIn,
}

abstract class AuthService extends ChangeNotifier {
  User get user;
  AuthStatus get status;

  Future<bool> signIn({
    required String email,
    required String password,
    required bool autoLogin,
  });
  // Future<bool> refreshToken();

  void signOut();
}
