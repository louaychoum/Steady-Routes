import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/driver.dart';

class DriversService with ChangeNotifier {
  List<Driver> _drivers = [];
  List<Driver> get drivers => [..._drivers];
  Driver findById(int id) {
    return _drivers.firstWhere((driver) => driver.id == id);
  }

  Future<bool> fetchDrivers(String jwt) async {
    try {
      const url = '${apiBase}Drivers_DataModel.json';
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
      _drivers.clear();
      final parsedResponse =
          jsonDecode(response)['getDrivers']['out']['body']['drivers'] as List;
      final List<Driver> loadedDrivers = [];
      for (int i = 0; i < parsedResponse.length; i++) {
        final parsedResponseItem = parsedResponse[i];
        loadedDrivers.add(
          Driver.fromJson(parsedResponseItem),
        );
      }
      _drivers = loadedDrivers;
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
