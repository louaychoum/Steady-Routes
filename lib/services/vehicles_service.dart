import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logging/logging.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/dio_exception.dart';
import 'package:steadyroutes/models/vehicle.dart';
import 'package:steadyroutes/services/web_auth_service.dart';

class VehiclesService with ChangeNotifier {
  static final _log = Logger('Vehicles Service');
  final Dio _dio = Dio(options);
  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => [..._vehicles];

  Vehicle findById(String id) {
    return _vehicles.firstWhere((vehicle) => vehicle.id == id);
  }

  Future<bool> fetchVehicles(
    String jwt,
    String courierId,
  ) async {
    _log.info('fetching vehicles');
    try {
      final response = await _dio.get(
        // courierId.isNotEmpty ? '/vehicles/courier/$courierId' : '/vehicles',
        '/vehicles',
        options: Options(
          headers: {'Authorization': ' x $jwt'},
        ),
      );
      _vehicles.clear();
      final parsedResponse =
          jsonDecode(response.toString()) as Map<String, dynamic>;
      final vehiclesCount = parsedResponse['count'] as int;
      final List<Vehicle> loadedVehicles = [];
      for (int i = 0; i < vehiclesCount; i++) {
        final parsedVehicleItem =
            parsedResponse['vehicles'][i] as Map<String, dynamic>;
        loadedVehicles.add(
          Vehicle.fromJson(
            parsedVehicleItem,
          ),
        );
      }
      _vehicles = loadedVehicles;
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

  Future<bool> deleteVehicle(
    String jwt,
    String id,
  ) async {
    _log.info('deleting vehicle');
    try {
      final response = await _dio.delete(
        '/vehicles/$id',
        options: Options(
          headers: {'Authorization': ' x $jwt'},
        ),
      );
      final existingVehicleIndex = _vehicles.indexWhere(
        (driver) => driver.id == id,
      );
      Vehicle? existingVehicles = _vehicles[existingVehicleIndex];
      _vehicles.removeAt(existingVehicleIndex);
      notifyListeners();
      existingVehicles = null;
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

  Future<bool> addVehicle(
    String jwt,
    String courierId,
    Vehicle _editedVehicle,
  ) async {
    _log.info('adding vehicle');
    try {
      final newVehicle = Vehicle(
        name: _editedVehicle.name,
        plateNumber: _editedVehicle.plateNumber,
        category: _editedVehicle.category,
        status: _editedVehicle.status,
        registrationExDate: _editedVehicle.registrationExDate,
        rtaNumber: _editedVehicle.rtaNumber,
        rtaExDate: _editedVehicle.rtaExDate,
      );
      final response = await _dio.post(
        '/vehicles/',
        options: Options(
          headers: {
            'Authorization': ' x $jwt',
          },
        ),
        data: newVehicle.toJson(),
      );

      vehicles.add(newVehicle);
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
