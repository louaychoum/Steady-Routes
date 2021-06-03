import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/courier.dart';
import 'package:steadyroutes/models/dio_exception.dart';
import 'package:steadyroutes/models/user.dart';
import 'package:steadyroutes/root.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';

class WebAuthService with ChangeNotifier implements AuthService {
  static final _log = Logger('WebAuthService');
  static final WebAuthService _instance = WebAuthService._internal();
  static const userPrefKey = "USER_PREF_KEY";
  // final Uri _baseUrl = Uri.parse("https://dropshoptest.herokuapp.com/");
  final Dio _dio = Dio(options);
  User? _user;
  Courier? _courier;
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
              email: storedUser.email,
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

  Future<void> fillCourierInfo(
    String id,
    String jwt,
  ) async {
    try {
      throw UnimplementedError('this error');
      if (id.isNotEmpty) {
        final request = await _dio.get(
          '/couriers/user/$id',
          options: Options(
            headers: {'Authorization': ' x $jwt'},
          ),
        );
        final response = json.decode(
          request.toString(),
        );
        print(response['courier']);
        _courier = Courier.fromJson(
          response['courier'] as Map<String, dynamic>,
        );
      }
    } catch (error) {
      _log.warning('dd', error);
    }
  }

  @override
  Future<bool> signIn({
    required String email,
    required String password,
    bool? autoLogin,
  }) async {
    _log.info('Sign In Called');
    print('username $email');
    print('password $password');
    print(_user);
    // final uri = Uri.parse('${_baseUrl}users/login');
    try {
      final response = await _dio.post(
        '/users/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      final append = json.decode(response.toString()) as Map<String, dynamic>;
      append['email'] = email;
      append['password'] = password;
      _user = User.fromJson(append);
      if (_user == null) {
        return false;
      }
      if (autoLogin == true) {
        _log.info('Auto Login is true');
        saveUserInPref();
      }
      if (_user?.role == 'courier') {
        await fillCourierInfo(
          _user?.userId ?? '',
          _user?.token ?? '',
        );
        setStatus(AuthStatus.adminLoggedIn);
      }
      if (_user?.role == 'supplier') {
        setStatus(AuthStatus.adminLoggedIn);
      } else {
        setStatus(AuthStatus.driverLoggedIn);
      }
      // _user = User.fromJson({"email": email, "password": password});
      return true;
    } on TimeoutException catch (error) {
      _log.warning('[Timeout] $error');
      return false;
      // throw TimeoutException(error.toString());
    } on SocketException catch (error) {
      _log.warning('[Socket] $error');
      return false;
      // throw SocketException(error.toString());
    } on DioError catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      _log.warning('(Dio) $errorMessage');
      return false;
    } catch (error) {
      _log.warning('[Other] $error');
      return false;
    }
    // try {
    //  http
    //     .post(
    //       uri,
    //       headers: {"Content-Type": "application/x-www-form-urlencoded"},
    //       body: json.encode(
    //         {
    //           'email': username,
    //           'password': password,
    //         },
    //       ),
    //     )
    //     .timeout(const Duration(seconds: 10));

    // print(request.statusCode);
    // if (request.statusCode != 200) {
    //   print('status error');
    //   throw HttpException(request.toString());
    //   // return false;
    // }
    //  final resuri =Uri.parse('json.decode(request.body)["userId"]'),

    // final id = json.decode(request.body)["userId"];
    // final response = await http.get(Uri.parse('${_baseUrl}user/$id'));

    // }
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
  Future<bool> processApiError(Response<dynamic> response) async {
    if (response.statusCode! < 400 || response.statusCode! > 499) {
      return false;
    }
    final bool didRefresh = await refreshToken();
    if (!didRefresh) {
      signOut();
      return false;
    }
    return true;
  }

  Future<bool> refreshToken() async {
    _log.info('refreshing Token');
    try {
      final response = await _dio.post(
        '/users/login',
        data: {
          'email': _user?.email,
          'password': _user?.password,
        },
      );
      final user = json.decode(response.toString()) as Map<String, dynamic>;
      _user?.token = user['token'].toString();
      saveUserInPref();
      return true;
    } on TimeoutException catch (_) {
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

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
    if (userPref == '' || userPref == 'null' || userPref == null) {
      setStatus(AuthStatus.notLoggedIn);
      return null;
    }
    return _user = User.fromJson(json.decode(userPref) as Map<String, dynamic>);
  }

  @override
  AuthStatus get status => _status;

  @override
  User get user =>
      _user ??
      User(
        userId: '',
        email: '',
        password: '',
        role: '',
        token: '',
      );

  @override
  Courier get courier =>
      _courier ??
      Courier(
        id: '',
        name: '',
        phone: null,
        user: _user,
        location: null,
      );
}
