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

  Future<bool> signIn({String username, String password, bool autoLogin});

  void signOut();
}
