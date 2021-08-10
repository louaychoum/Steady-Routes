import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/attendance.dart';
import 'package:steadyroutes/models/dio_exception.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/services/web_auth_service.dart';

class AttendanceService with ChangeNotifier {
  static final _log = Logger('Attendance Service');
  final Dio _dio = Dio(options);
  List<Attendance> _attendances = [];
  List<Attendance> get attendances => [..._attendances];
  Attendance findById(String id) {
    return _attendances.firstWhere(
      (attendance) => attendance.id == id,
    );
  }

  Future<bool> fetchAttendace(
    String jwt,
  ) async {
    _log.info('fetching attendances');
    try {
      final response = await _dio.get(
        '/attendance',
        options: Options(
          headers: {'Authorization': ' x $jwt'},
        ),
      );
      _log.info(response);
      _attendances.clear();
      final parsedResponse =
          jsonDecode(response.toString()) as Map<String, dynamic>;
      final attendanceCount = parsedResponse['count'] as int;
      final List<Attendance> loadedAttendances = [];
      for (int i = 0; i < attendanceCount; i++) {
        final parsedAttendanceItem =
            parsedResponse['attendance'][i] as Map<String, dynamic>;
        loadedAttendances.add(
          Attendance.fromJson(parsedAttendanceItem),
        );
      }
      _attendances = loadedAttendances;
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

  Future<String?> addAttendance({
    required Driver? driver,
    //todo: vehicleId
    required String? locationId,
    required String date,
    required String action,
    required double lat,
    required double long,
    required String token,
  }) async {
    _log.info('adding attendance');
    try {
      final Attendance newAttendance = Attendance(
        driverId: driver?.id ?? '',
        locationId: locationId ?? '',
        vehicleId: '60bd053610bd6b2cb7128fb1',
        date: date,
        action: action,
        latitude: lat,
        longitude: long,
      );
      final response = await _dio.post(
        '/attendance/',
        options: Options(
          headers: {
            'Authorization': ' x $token',
          },
        ),
        data: newAttendance.toJson(),
      );
      _log.info(response);
      attendances.add(newAttendance);
      notifyListeners();
    } on TimeoutException catch (error) {
      _log.warning('[Timeout] $error');
      return error.toString();
      // throw TimeoutException(error.toString());
    } on SocketException catch (error) {
      _log.warning('[Socket] $error');
      return error.toString();
      // throw SocketException(error.toString());
    } on DioError catch (error) {
      if (error.response == null) {
        return error.response?.data.toString();
      }
      if (error.response?.statusCode == 400) {
        //Todo show error message
        return error.response?.data.toString();
      }
      if (error.response?.statusCode != 200) {
        final errorMessage = DioExceptions.fromDioError(error).toString();
        _log.warning('[Dio] $errorMessage');
        WebAuthService().processApiError(error.response!);
        return error.response?.data.toString();
      }
      final errorMessage = DioExceptions.fromDioError(error).toString();
      _log.warning('[Dio] $errorMessage');
      return error.response?.data.toString();
    } catch (error) {
      _log.warning('[Other] $error');
      return error.toString();
    }
  }
}
