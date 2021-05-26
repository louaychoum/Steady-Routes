import 'package:flutter/foundation.dart';

import 'package:steadyroutes/services/drivers_service.dart';
import 'package:steadyroutes/services/receipts_service.dart';
import 'package:steadyroutes/services/vehicles_service.dart';

class SteadyApiService with ChangeNotifier {
  DriversService driversService = DriversService();
  ReceiptsService receiptsService = ReceiptsService();
  VehiclesService vehiclesService = VehiclesService();

  SteadyApiService() {
    driversService.addListener(() {
      notifyListeners();
    });
    receiptsService.addListener(() {
      notifyListeners();
    });
    vehiclesService.addListener(() {
      notifyListeners();
    });
  }
}
