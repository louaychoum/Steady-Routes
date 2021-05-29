import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/user.dart';
import 'package:steadyroutes/root.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';

class WebAuthService with ChangeNotifier implements AuthService {
  static final _log = Logger('WebAuthService');
  static final WebAuthService _instance = WebAuthService._internal();
  static const userPrefKey = "USER_PREF_KEY";
  final Uri _baseUrl = Uri.parse("http://10.0.2.2:9001/");
  User? _user;
  late AuthStatus _status;

  factory WebAuthService() {
    _log.info('Constructor Called');
    return _instance;
  }

  WebAuthService._internal() {
    _log.info('internal Called');
    // setStatus(AuthStatus.adminLoggedIn);
    _status = AuthStatus.notDetermined;
    // check storage and try to login
    getUserInPref().then(
      (storedUser) {
        if (storedUser != null) {
          try {
            signIn(
              username: storedUser.username,
              password: storedUser.password,
              autoLogin: true,
            ).then((value) {
              if (!value) {
                _log.warning("failed to sign in");
                signOut();
              }
            });
          } catch (error) {
            _log.warning("failed to get user's prefs");
          }
        }
      },
    );
  }

  void setStatus(AuthStatus status) {
    _log.info(
        'SetStatus Called, new staus is ${status.toString().split('.').last}');
    _status = status;
    notifyListeners();
  }

  @override
  Future<bool> signIn({
    required String username,
    required String password,
    required bool autoLogin,
  }) async {
    _log.info('Sign In Called');
    try {
      // final url = '${apiBase}login.json';
      // final response = await rootBundle.loadString(url);
      print('username $username');
      print('password $password');

      final uri = Uri.parse('${_baseUrl}user/login');
      final request = await http
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: json.encode(
              {
                'username': username,
                'password': password,
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      print(request.statusCode);

      if (request.statusCode != 200) {
        return false;
      }
      //  final resuri =Uri.parse('json.decode(request.body)["userId"]'),
      final id = json.decode(request.body)["userId"];
      final response = await http.get(Uri.parse('${_baseUrl}user/$id'));
      _user = User.fromJson(json.decode(response.body) as Map<String, dynamic>);
      if (autoLogin) {
        _log.info('Auto Login is true');
        saveUserInPref();
      }
      if (_user!.access == 'admin') {
        setStatus(AuthStatus.adminLoggedIn);
      } else {
        setStatus(AuthStatus.driverLoggedIn);
      }
      return true;
    } on TimeoutException catch (error) {
      _log.warning(error);
      throw TimeoutException(error.toString());
    } on SocketException catch (error) {
      _log.warning(error);
      throw SocketException(error.toString());
    } catch (error) {
      _log.warning(error);
      return false;
    }
  }

  // Future authenticateUser(String username, String password) async {
  //   // final ApiResponse _apiResponse = ApiResponse();
  //   try {
  //     final response =
  //         await http.post(Uri.parse('$_baseUrl user/login'), body: {
  //       'username': username,
  //       'password': password,
  //     });

  //     switch (response.statusCode) {
  //       case 200:
  //         _apiResponse.Data =
  //             User.fromJson(json.decode(response.body) as Map<String, dynamic>);
  //         break;
  //       case 401:
  //         _apiResponse.ApiError = ApiError.fromJson(
  //             json.decode(response.body) as Map<String, dynamic>);
  //         break;
  //       default:
  //         _apiResponse.ApiError = ApiError.fromJson(
  //             json.decode(response.body) as Map<String, dynamic>);
  //         break;
  //     }
  //   } on SocketException {
  //     _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
  //   }
  //   return _apiResponse;
  // }

  // Future getUserDetails(String userId) async {
  //   // final ApiResponse _apiResponse = ApiResponse();
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$_baseUrl user/$userId'),
  //     );

  //     switch (response.statusCode) {
  //       case 200:
  //         _apiResponse.Data =
  //             User.fromJson(json.decode(response.body) as Map<String, dynamic>);
  //         break;
  //       case 401:
  //         print((_apiResponse.ApiError as ApiError).error);
  //         _apiResponse.ApiError = ApiError.fromJson(
  //             json.decode(response.body) as Map<String, dynamic>);
  //         break;
  //       default:
  //         print((_apiResponse.ApiError as ApiError).error);
  //         _apiResponse.ApiError = ApiError.fromJson(
  //             json.decode(response.body) as Map<String, dynamic>);
  //         break;
  //     }
  //   } on SocketException {
  //     _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
  //   }
  //   return _apiResponse;
  // }

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

    NavigationService.navigatorKey.currentState!.popUntil(
      ModalRoute.withName(Root.routeName),
    );
  }

  void saveUserInPref() {
    _log.info('saving to prefs');
    SharedPreferences.getInstance().then((pref) {
      pref.setString(userPrefKey, json.encode(_user));
    });
  }

  Future<User?> getUserInPref() async {
    _log.info("Getting user's prefrences");
    final pref = await SharedPreferences.getInstance();
    final userPref = pref.getString(userPrefKey);
    if (userPref != null) {
      return _user =
          User.fromJson(json.decode(userPref) as Map<String, dynamic>);
    } else {
      setStatus(AuthStatus.notLoggedIn);
    }
  }

  @override
  AuthStatus get status => _status;

  @override
  User get user => _user!;
}
