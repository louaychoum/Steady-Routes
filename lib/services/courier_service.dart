import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/courier.dart';
import 'package:steadyroutes/models/dio_exception.dart';
import 'package:steadyroutes/services/web_auth_service.dart';

class CouriersService with ChangeNotifier {
  static final _log = Logger('Courier Service');
  final Dio _dio = Dio(options);
  final List<Courier> _couriers = [];
  List<Courier> get couriers => [..._couriers];

  Courier findById(String id) {
    print('couriers $_couriers');
    return _couriers.firstWhere(
      (courier) => courier.id == id,
    );
  }

  Future<bool> addCourier(
    String jwt,
    Courier _editedCourier,
  ) async {
    _log.info('adding courier');
    try {
      final Courier newCourier = Courier(
        name: _editedCourier.name,
        phone: _editedCourier.phone,
        location: _editedCourier.location,
        user: null,
      );
      final response = await _dio.post(
        '/couriers',
        options: Options(
          headers: {
            'Authorization': ' x $jwt',
          },
        ),
        data: newCourier.toJson(),
      );
      _log.info(response);
      couriers.add(newCourier);
      notifyListeners();
      return true;
    } on TimeoutException catch (error) {
      _log.warning('[Timeout] ${error.message}');
      return false;
      // throw TimeoutException(error.toString());
    } on SocketException catch (error) {
      _log.warning('[Socket] ${error.message}');
      return false;
      // throw SocketException(error.toString());
    } on DioError catch (error) {
      if (error.response == null) {
        _log.warning('[Dio] ${error.message}');
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
}
