import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/courier.dart';
import 'package:steadyroutes/models/dio_exception.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/models/user.dart';
import 'package:steadyroutes/services/web_auth_service.dart';

class DriversService with ChangeNotifier {
  static final _log = Logger('Drivers Service');
  final Dio _dio = Dio(options);
  List<Driver> _drivers = [];
  List<Driver> get drivers => [..._drivers];
  Driver findById(String id) {
    return _drivers.firstWhere(
      (driver) => driver.id == id,
    );
  }

  Future<bool> fetchDrivers(String jwt, String courierId) async {
    _log.info('fetching drivers');
    try {
      final response = await _dio.get(
        courierId.isNotEmpty ? '/drivers/courier/$courierId' : '/drivers',
        options: Options(
          headers: {'Authorization': ' x $jwt'},
        ),
      );
      _drivers.clear();
      final parsedResponse =
          jsonDecode(response.toString()) as Map<String, dynamic>;
      final driversCount = parsedResponse['count'] as int;
      final List<Driver> loadedDrivers = [];
      for (int i = 0; i < driversCount; i++) {
        final parsedDriverItem =
            parsedResponse['Drivers'][i] as Map<String, dynamic>;
        loadedDrivers.add(
          Driver.fromJson(parsedDriverItem),
        );
      }
      _drivers = loadedDrivers;
      notifyListeners();
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
      if (error.response == null) {
        return false;
      }
      if (error.response?.statusCode != 200) {
        final errorMessage = DioExceptions.fromDioError(error).toString();
        _log.warning('[Dio] $errorMessage');
        WebAuthService().processApiError(error.response!);
        return false;
      }
      final errorMessage = DioExceptions.fromDioError(error).toString();
      _log.warning('[Dio] $errorMessage');
      return false;
    } on Exception catch (error) {
      _log.warning('[Exception] $error');
      return false;
    } catch (error) {
      _log.warning('[Other] $error');
      return false;
    }
  }

  Future<bool> addDriver(
    String jwt,
    String courierId,
    Driver _editedDriver,
  ) async {
    _log.info('adding driver');
    try {
      final Driver newDriver = Driver(
        name: _editedDriver.name,
        phone: _editedDriver.phone,
        drivingLicense: _editedDriver.drivingLicense,
        company: _editedDriver.company,
        drivingLicenseExDate: _editedDriver.drivingLicenseExDate,
        passportExDate: _editedDriver.passportExDate,
        passportNumber: _editedDriver.passportNumber,
        plateNumber: _editedDriver.plateNumber,
        visaExDate: _editedDriver.visaExDate,
        visaNumber: _editedDriver.visaNumber,
        user: User(
          email: _editedDriver.email ?? '',
          password: _editedDriver.password ?? '',
          role: 'driver',
          token: jwt,
          userId: '',
          courier: null,
        ),
        courierId: courierId,
        email: _editedDriver.email,
        password: _editedDriver.password,
      );
      final response = await _dio.post(
        '/drivers/',
        options: Options(
          headers: {
            'Authorization': ' x $jwt',
          },
        ),
        data: newDriver.toJson(),
      );

      drivers.add(newDriver);
      notifyListeners();
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
      if (error.response == null) {
        return false;
      }
      if (error.response?.statusCode != 200) {
        final errorMessage = DioExceptions.fromDioError(error).toString();
        _log.warning('[Dio] $errorMessage');
        WebAuthService().processApiError(error.response!);
        return false;
      }
      final errorMessage = DioExceptions.fromDioError(error).toString();
      _log.warning('[Dio] $errorMessage');
      return false;
    } on Exception catch (error) {
      _log.warning('[Exception] $error');
      return false;
    } catch (error) {
      _log.warning('[Other] $error');
      return false;
    }
  }

  Future<bool> deleteDriver(
    String jwt,
    String id,
  ) async {
    _log.info('deleting driver');
    try {
      final response = await _dio.delete(
        '/drivers/$id',
        options: Options(
          headers: {'Authorization': ' x $jwt'},
        ),
      );
      final existingDriverIndex = _drivers.indexWhere(
        (driver) => driver.id == id,
      );
      Driver? existingDrivers = _drivers[existingDriverIndex];
      _drivers.removeAt(existingDriverIndex);
      notifyListeners();

      existingDrivers = null;
      return true;
    } on TimeoutException catch (error) {
      _log.warning('[Timeout] $error');
      return false;
    } on SocketException catch (error) {
      _log.warning('[Socket] $error');
      return false;
    } on DioError catch (error) {
      if (error.response == null) {
        return false;
      }
      if (error.response?.statusCode != 200) {
        final errorMessage = DioExceptions.fromDioError(error).toString();
        _log.warning('[Dio] $errorMessage');
        WebAuthService().processApiError(error.response!);
        return false;
      }
      final errorMessage = DioExceptions.fromDioError(error).toString();
      _log.warning('[Dio] $errorMessage');
      return false;
    } on Exception catch (error) {
      _log.warning('[Exception] $error');
      return false;
    } catch (error) {
      _log.warning('[Other] $error');
      return false;
    }
  }

  // Future<bool> upload(String jwt, File img) async {
  //   try {
  //     List<String> mime = lookupMimeType(img.path).split('/');
  //     var uri = Uri.parse('${API_BASE}receipts/');

  //     var request = http.MultipartRequest('POST', uri)
  //       ..headers[HttpHeaders.acceptHeader] = "application/json"
  //       ..headers['api-token'] = jwt
  //       ..files.add(await http.MultipartFile.fromPath('files', img.path,
  //           filename: img.path.split('/').last,
  //           contentType: MediaType(mime[0], mime[1])));

  //     final response = await http.Response.fromStream(await request.send());

  //     print(response.statusCode);
  //     print(response.body);

  //     final parsed = jsonDecode(response.body) as Map<String, dynamic>;
  //     if (response.statusCode != 200) {
  //       return false;
  //     }
  //     return true;
  //   } on TimeoutException catch (_) {
  //     return false;
  //   } on SocketException catch (_) {
  //     return false;
  //   } on FormatException catch (_) {
  //     return false;
  //   }
  // }
}
