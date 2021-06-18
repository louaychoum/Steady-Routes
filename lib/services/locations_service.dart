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
import 'package:steadyroutes/models/location.dart';
import 'package:steadyroutes/models/user.dart';
import 'package:steadyroutes/services/web_auth_service.dart';

class LocationsService with ChangeNotifier {
  static final _log = Logger('Locations Service');
  final Dio _dio = Dio(options);
  List<Location> _locations = [];
  List<Location> get locations => [..._locations];
  Location findById(String id) {
    return _locations.firstWhere(
      (location) => location.id == id,
    );
  }

  Future<bool> fetchLocation(
    String jwt,
  ) async {
    _log.info('fetching locations');
    try {
      final response = await _dio.get(
        '/locations',
        options: Options(
          headers: {'Authorization': ' x $jwt'},
        ),
      );
      _locations.clear();
      final parsedResponse =
          jsonDecode(response.toString()) as Map<String, dynamic>;
      final locationsCount = parsedResponse['count'] as int;
      final List<Location> loadedLocations = [];
      for (int i = 0; i < locationsCount; i++) {
        final parsedLocationItem =
            parsedResponse['locations'][i] as Map<String, dynamic>;
        loadedLocations.add(
          Location.fromJson(parsedLocationItem),
        );
      }
      _locations = loadedLocations;
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


  // Future<void> deleteDriver(
  //   String jwt,
  //   String id,
  // ) async {
  //   // final response = await _dio.delete(
  //   //   '/drivers/$id',
  //   //   options: Options(
  //   //     headers: {'Authorization': ' x $jwt'},
  //   //   ),
  //   // );
  //   final existingDriverIndex = _locations.indexWhere(
  //     (driver) => driver.id == id,
  //   );
  //   Driver? existingDrivers = _locations[existingDriverIndex];
  //   _locations.removeAt(existingDriverIndex);
  //   notifyListeners();
  //   // if (response.statusCode! >= 400) {
  //   //   _drivers.insert(existingDriverIndex, existingDrivers);
  //   //   notifyListeners();
  //   //   throw 'Could not delete product.';
  //   // }
  //   existingDrivers = null;
  // }

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
