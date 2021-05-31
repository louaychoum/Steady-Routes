import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/dio_exception.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/models/user.dart';
import 'package:steadyroutes/services/web_auth_service.dart';

class DriversService with ChangeNotifier {
  static final _log = Logger('Drivers Service');
  final Dio _dio = Dio(options);
  List<Driver> _drivers = [];
  List<Driver> get drivers => [..._drivers];
  // Driver findById(int id) {
  //   return _drivers.firstWhere((driver) => driver.id == id);
  // }

  Future<bool> fetchDrivers(String jwt) async {
    try {
      // const url = '${apiBase}Drivers_DataModel.json';
      // final response = await rootBundle.loadString(url);
      final response = await _dio.get(
        '/drivers',
        options: Options(
          headers: {'Authorization': ' x $jwt'},
        ),
      );
      if (response.statusCode != 200) {
        WebAuthService().processApiError(response);
        return false;
      }

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

  Future<void> addDriver(
    String jwt,
    Driver _editedDriver,
  ) async {
    try {
      // final response = await _dio.post(
      //   '/drivers',
      //   options: Options(
      //     headers: {'Authorization': ' x $jwt'},
      //   ),
      //   data: {
      //     'id': _editedDriver.id,
      //     'name': _editedDriver.name,
      //     'phone': _editedDriver.phone,
      //     'drivingLicense': _editedDriver.drivingLicense,
      //     'company': _editedDriver.company,
      //     'drivingLicenseExDate': _editedDriver.drivingLicenseExDate,
      //     'passportExDate': _editedDriver.passportExDate,
      //     'passportNumber': _editedDriver.passportNumber,
      //     'plateNumber': _editedDriver.plateNumber,
      //     'visaExDate': _editedDriver.visaExDate,
      //     'visaNumber': _editedDriver.visaNumber,
      //   },
      // );
      // if (response.statusCode != 200) {
      //   WebAuthService().processApiError(response);
      // }

      final newDriver = Driver(
        user: User(
          email: '',
          password: '',
          role: '',
          token: '',
          userId: '',
        ),
        id: 'a1',
        // id: json.decode(response.toString())['Drivers']['_id'].toString(),
        // user: json.decode(response.toString())['Drivers']['user'] as User,
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
      );
      drivers.add(newDriver);
      notifyListeners();
    } catch (error) {
      _log.warning(error);
      rethrow;
    }
  }

  Future<void> deleteDriver(
    String jwt,
    String id,
  ) async {
    // final response = await _dio.delete(
    //   '/drivers/$id',
    //   options: Options(
    //     headers: {'Authorization': ' x $jwt'},
    //   ),
    // );
    final existingDriverIndex = _drivers.indexWhere(
      (driver) => driver.id == id,
    );
    Driver? existingDrivers = _drivers[existingDriverIndex];
    _drivers.removeAt(existingDriverIndex);
    notifyListeners();
    // if (response.statusCode! >= 400) {
    //   _drivers.insert(existingDriverIndex, existingDrivers);
    //   notifyListeners();
    //   throw 'Could not delete product.';
    // }
    existingDrivers = null;
  }
  // Future<bool> assignReceiptToTransaction(
  //     String jwt, int receiptId, int transactionId) async {
  //   try {
  //     var url = '${API_BASE}receipts/$receiptId';
  //     var response = await http
  //         .put(
  //           url,
  //           headers: {
  //             "Content-Type": "application/json",
  //             "api-token": jwt,
  //           },
  //           body: json.encode(
  //             {'transaction_id': transactionId},
  //           ),
  //         )
  //         .timeout(
  //           const Duration(seconds: 10),
  //         );
  //     print('Response body: ${response.body}');
  //     print('Response body: ${response.statusCode}');
  //     if (response.statusCode != 200) {
  //       return false;
  //     }
  //     return true;
  //   } on TimeoutException catch (_) {
  //     return false;
  //   } on SocketException catch (_) {
  //     return false;
  //   }
  // }

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
