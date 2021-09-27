import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logging/logging.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/dio_exception.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/models/receipt.dart';
import 'package:steadyroutes/models/vehicle.dart';
import 'package:steadyroutes/services/web_auth_service.dart';

class ReceiptsService with ChangeNotifier {
  static final _log = Logger('Receipt Service');
  final Dio _dio = Dio(options);
  List<Receipt> _receipt = [];
  List<Receipt> get receipts => [..._receipt];
  List<Driver> _driversReport = [];
  List<Driver> get driversReport => [..._driversReport];
  List<Vehicle> _vehiclesReport = [];
  List<Vehicle> get vehiclesReport => [..._vehiclesReport];

  Future<bool> fetchReceipts(String jwt, String driverId) async {
    try {
      const url = 'Receipt_DataModel.json';
      final response = await rootBundle.loadString(url);

      // final response = await http.get(
      //   url,
      //   headers: {
      //     "Content-Type": "application/json",
      //     "api-token": jwt,
      //   },
      // ).timeout(
      //   const Duration(seconds: 10),
      // );
      // print('Response body: ${response.body}');
      // print('Response body: ${response.statusCode}');
      // TODO: manage all error codes
      // if (response.statusCode != 200) {
      //   WebAuthService().processApiError(response);
      //   return false;
      // }
      _receipt.clear();
      final parsedResponse = jsonDecode(response)['getReceipts']['out']['body']
          ['receipts'] as List;
      final List<Receipt> loadedReceipts = [];
      for (int i = 0; i < parsedResponse.length; i++) {
        final parsedResponseItem = parsedResponse[i];
        final receivedId = parsedResponse[i]['driverId'];

        if (receivedId == driverId) {
          // print(parsedResponse[i]['driverId']);
          loadedReceipts.add(
            Receipt.fromJson(parsedResponseItem),
          );
        }
      }
      _receipt = loadedReceipts;
      notifyListeners();
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

  Future<bool> fetchExpiryReports(String jwt, String category, String type,
      int monthsCount, String courierId) async {
    _log.info('Fetching Expiry Reports');
    try {
      final response = await _dio.get(
        '/$category/$type/expiry/$courierId',
        options: Options(
          headers: {
            'Authorization': ' x $jwt',
            'aheadMonths': monthsCount,
          },
        ),
      );
      print(category);
      _log.info(response);
      _driversReport.clear();
      _vehiclesReport.clear();
      final parsedResponse =
          jsonDecode(response.toString()) as Map<String, dynamic>;
      final driversCount = parsedResponse['count'] as int;
      final vehiclesCount = parsedResponse['count'] as int;
      final List<Driver> loadedDrivers = [];
      final List<Vehicle> loadedVehicles = [];
      for (int i = 0; i < driversCount || i < vehiclesCount; i++) {
        final parsedItem = parsedResponse[category][i] as Map<String, dynamic>;
        if (category.contains('vehicles')) {
          loadedVehicles.add(
            Vehicle.fromJson(parsedItem),
          );
          _vehiclesReport = loadedVehicles;
        } else {
          loadedDrivers.add(
            Driver.fromJsonLogin(parsedItem),
          );
          _driversReport = loadedDrivers;
        }
      }
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

  void updateReceiptStatus(int id, Status newStatus) {
    final receiptIndex = receipts.indexWhere((index) => index.id == id);
    if (receiptIndex >= 0) {
      receipts[receiptIndex].status = newStatus;
      notifyListeners();
    } else {
      debugPrint('...');
    }
  }
  // Future<void> deleteDriver(int id) async {
  //   final url = Uri.parse(
  //     'https://myshop-d5f4e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken',
  //   );
  //   final existingDriverIndex =
  //       _drivers.indexWhere((driver) => driver.id == id);
  //   var existingDrivers = _drivers[existingDriverIndex];
  //   _drivers.removeAt(existingDriverIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);
  //   if (response.statusCode >= 400) {
  //     _drivers.insert(existingDriverIndex, existingDrivers);
  //     notifyListeners();
  //     throw HttpException('Could not delete product.');
  //   }
  //   existingDrivers = null;
  // }

  //  Future<void> updateReceipt(int id, Receipt newReceipt) async {
  //   final receiptIndex = _receipts.indexWhere((index) => index.id == id);
  //   if (receiptIndex >= 0) {
  //     // final url = Uri.parse(
  //     //     'https://myshop-d5f4e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
  //     // await http.patch(url,
  //     //     body: json.encode({
  //     //       'name': newDriver.name,
  //     //       'username': newDriver.username,
  //     //       'plateNumber': newDriver.plateNumber,
  //     //       'drivingLicense': newDriver.drivingLicense,
  //     //       'drivingLicenseExDate': newDriver.drivingLicenseExDate,
  //     //       'company': newDriver.company,
  //     //       'passportNumber': newDriver.passportNumber,
  //     //       'passportExDate': newDriver.passportExDate,
  //     //       'visaNumber': newDriver.visaNumber,
  //     //       'visaExDate': newDriver.visaExDate,
  //     //     }));

  //     _receipts[receiptIndex] = newReceipt;
  //     notifyListeners();
  //   } else {
  //     debugPrint('...');
  //   }
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
