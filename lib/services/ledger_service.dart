import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/dio_exception.dart';
import 'package:steadyroutes/models/ledger.dart';
import 'package:steadyroutes/services/web_auth_service.dart';
import 'package:steadyroutes/widgets/upload_receipt_info.dart';

class LedgerService with ChangeNotifier {
  static final _log = Logger('Ledger Service');
  final Dio _dio = Dio(options);
  List<Ledger> _ledgers = [];
  List<Ledger> get ledgers => [..._ledgers];

  // Ledger findById(String id) {
  //   return _locations.firstWhere(
  //     (location) => location.id == id,
  //   );
  // }

  Future<bool> fetchLedger(
    String jwt,
  ) async {
    _log.info('Fetching ledgers');
    try {
      final response = await _dio.get(
        '/ledgers',
        options: Options(
          headers: {'Authorization': ' x $jwt'},
        ),
      );
      _log.info(response);
      _ledgers.clear();
      final parsedResponse =
          jsonDecode(response.toString()) as Map<String, dynamic>;
      final ledgersCount = parsedResponse['count'] as int;
      final List<Ledger> loadedLedgers = [];
      for (int i = 0; i < ledgersCount; i++) {
        final parsedLedgerItem =
            parsedResponse['ledger'][i] as Map<String, dynamic>;
        loadedLedgers.add(
          Ledger.fromJson(parsedLedgerItem),
        );
      }
      _ledgers = loadedLedgers;
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
      if (error.response?.statusCode != 200 ||
          error.response?.statusCode != 201) {
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

  Future<bool> uploadLedger(
    String jwt,
    File img,
    Ledger _editedLedger,
  ) async {
    try {
      _log.info('Uploading Ledger');

      final filePath = img.absolute.path;
      final lastIndex = filePath.lastIndexOf(
        RegExp(r'.jp'),
      );

      final Ledger newLedger = Ledger(
        driverId: _editedLedger.driverId,
        vehicleId: _editedLedger.vehicleId,
        action: _editedLedger.action,
        amount: _editedLedger.amount,
      );

      final ledgerBody = {
        ...newLedger.toJson(),
        ...{
          "fileformat": filePath.substring(lastIndex + 1),
        }
      };
      final response = await _dio.post(
        '/ledgers',
        options: Options(
          headers: {'Authorization': ' x $jwt'},
        ),
        data: ledgerBody,
      );

      _log.info(response);

      final parsed = jsonDecode(response.toString()) as Map<String, dynamic>?;
      final receiptName = parsed?['createdLedger']['receipt'].toString();
      final FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(img.path, filename: receiptName),
      });

      final fileResponse = await _dio.post(
        '/files',
        options: Options(
          headers: {
            'Authorization': ' x $jwt',
            'filename': receiptName,
          },
        ),
        data: formData,
        onSendProgress: (int sent, int total) {
          final progress = sent / total;
          _log.info(
            'Upload progress: $progress ($sent/$total)',
          );
        },
      );

      _log.info(fileResponse);

      if ((response.statusCode != 200 && response.statusCode != 201) ||
          (fileResponse.statusCode != 200 && fileResponse.statusCode != 201)) {
        _log.warning('${response.statusCode} ${fileResponse.statusCode}');
        return false;
      }
      return true;
      //Todo make all catches like this one to LOG
    } on TimeoutException catch (error) {
      _log.warning(error);
      return false;
    } on SocketException catch (error) {
      _log.warning(error);
      return false;
    } on FormatException catch (error) {
      _log.warning(error);
      return false;
    }
  }
}
