import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/user.dart';
import 'package:steadyroutes/screens/root.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';

class WebAuthService with ChangeNotifier implements AuthService {
  static final _log = Logger('WebAuthService');
  static final WebAuthService _instance = WebAuthService._internal();
  static const userPrefKey = "USER_PREF_KEY";
  User _user;
  AuthStatus _status;

  factory WebAuthService() {
    _log.info('Constructor Called');
    return _instance;
  }

  WebAuthService._internal() {
    _log.info('internal Called');
    // setStatus(AuthStatus.adminLoggedIn);
    _status = AuthStatus.notDetermined;
    // check storage and try to login
    SharedPreferences.getInstance().then((pref) {
      final String userPref = pref.getString(userPrefKey);
      if (userPref != null) {
        _user = User.fromJson(json.decode(userPref) as Map<String, dynamic>);
        if (_user.access == 'admin') {
          setStatus(AuthStatus.adminLoggedIn);
        } else {
          setStatus(AuthStatus.driverLoggedIn);
        }
      } else {
        setStatus(AuthStatus.notLoggedIn);
      }
    });
  }

  void setStatus(AuthStatus status) {
    _log.info('SetStatus Called');
    _status = status;
    notifyListeners();
  }

  @override
  Future<bool> signIn(
      {String username, String password, bool autoLogin}) async {
    _log.info('Sign In Called');
    try {
      final url = '${apiBase}login.json';
      final response = await rootBundle.loadString(url);
      // var response = await http
      //     .post(url,
      //         headers: {"Content-Type": "application/json"},
      //         body: json.encode({'email': email, 'password': password}))
      //     .timeout(const Duration(seconds: 10));

      // if (response.statusCode != 200) {
      //   return false;
      // }
      _user = User.fromJson(
          json.decode(response)['login']['in']['body'] as Map<String, dynamic>);
      if (autoLogin) {
        saveUserInPref();
      }
      if (_user.access == 'admin') {
        setStatus(AuthStatus.adminLoggedIn);
      } else {
        setStatus(AuthStatus.driverLoggedIn);
      }
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
    // on TimeoutException catch (_) {
    //   return false;
    // } on SocketException catch (_) {
    //   return false;
    // }
  }

  // Future<bool> processApiError(dynamic response) async {
  //   if (response.statusCode < 400 || response.statusCode > 499) {
  //     return false;
  //   }

  //   bool didRefresh = await this.refreshToken();
  //   if (!didRefresh) {
  //     this.signOut();
  //     return false;
  //   }
  //   return true;
  // }

  //  Future<bool> refreshToken() async {
  //   try {
  //     var url = '${API_BASE}users/token/refresh';
  //     var response = await http
  //         .post(url,
  //             headers: {"Content-Type": "application/json"},
  //             body: json.encode({'refresh': _user.refresh}))
  //         .timeout(const Duration(seconds: 10));
  //     if (response.statusCode != 200) {
  //       return false;
  //     }
  //     _user.jwt = json.decode(response.body)['jwt'];
  //     saveUserInPref();
  //     setStatus(AuthStatus.LOGGED_IN);
  //     return true;
  //   } on TimeoutException catch (_) {
  //     return false;
  //   } on SocketException catch (_) {
  //     return false;
  //   }
  // }

  @override
  void signOut() {
    _log.info('Sign Out Called');
    // http.delete(
    //   '${API_BASE}firebase/${this.firebaseToken}',
    //   headers: {"Content-Type": "application/json", "api-token": user.jwt},
    // );

    SharedPreferences.getInstance().then((pref) {
      pref.remove(userPrefKey);
    });
    setStatus(AuthStatus.notLoggedIn);

    NavigationService.navigatorKey.currentState
        .popUntil(ModalRoute.withName(Root.routeName));
  }

  void saveUserInPref() {
    SharedPreferences.getInstance().then((pref) {
      pref.setString(userPrefKey, json.encode(_user));
    });
  }

  @override
  AuthStatus get status => _status;

  @override
  User get user => _user;
}
