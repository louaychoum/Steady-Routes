import 'package:flutter/foundation.dart';
import 'package:steadyroutes/services/attendance_service.dart';
import 'package:steadyroutes/services/courier_service.dart';

import 'package:steadyroutes/services/drivers_service.dart';
import 'package:steadyroutes/services/ledger_service.dart';
import 'package:steadyroutes/services/locations_service.dart';
import 'package:steadyroutes/services/receipts_service.dart';
import 'package:steadyroutes/services/vehicles_service.dart';

class SteadyApiService with ChangeNotifier {
  CouriersService courierService = CouriersService();
  DriversService driversService = DriversService();
  ReceiptsService receiptsService = ReceiptsService();
  VehiclesService vehiclesService = VehiclesService();
  LocationsService locationsService = LocationsService();
  AttendanceService attendanceService = AttendanceService();
  LedgerService ledgerService = LedgerService();

  SteadyApiService() {
    driversService.addListener(() {
      notifyListeners();
    });
    courierService.addListener(() {
      notifyListeners();
    });
    receiptsService.addListener(() {
      notifyListeners();
    });
    vehiclesService.addListener(() {
      notifyListeners();
    });
    locationsService.addListener(() {
      notifyListeners();
    });
    attendanceService.addListener(() {
      notifyListeners();
    });
    ledgerService.addListener(() {
      notifyListeners();
    });
  }
}
