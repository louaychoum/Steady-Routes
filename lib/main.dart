import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/screens/adminDashBoardScreen/admin_dashboard_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/driverScreen/add_driver_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/driverScreen/driver_list_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/driverScreen/driver_receipts_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/receiptScreen/expiry_list_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/receiptScreen/expiry_report_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/receiptScreen/receipt_report_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/receiptScreen/receipt_review_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/receiptScreen/report_list_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/vehicleScreen/add_vehicle_screen.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/vehicleScreen/vehicle_list_screen.dart';
import 'package:steadyroutes/screens/driverDashBoardScreen/check_in_screen.dart';
import 'package:steadyroutes/screens/driverDashBoardScreen/check_out_screen.dart';
import 'package:steadyroutes/screens/driverDashBoardScreen/driver_dashboard_screen.dart';
import 'package:steadyroutes/screens/driverDashBoardScreen/upload_receipt_screen.dart';
import 'package:steadyroutes/screens/root.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/services/web_auth_service.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen(
    (record) {
      print(
          '[${record.level.name}]: ${record.loggerName} --- ${record.time} --- ${record.message}');
    },
    onError: (e) => print(e),
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => WebAuthService(),
        ),
        ChangeNotifierProvider<SteadyApiService>(
          create: (ctx) => SteadyApiService(),
        ),
      ],
      child: MaterialApp(
        title: 'Steady Routes',
        debugShowCheckedModeBanner: false,
        // home: AuthScreen(),
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.teal,
          appBarTheme: const AppBarTheme(
            actionsIconTheme: IconThemeData(
              color: Colors.red,
            ),
            iconTheme: IconThemeData(
              color: Colors.red,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 18),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              primary: Colors.red,
            ),
          ),

          // fontFamily: 'Lato',
          // pageTransitionsTheme: PageTransitionsTheme(
          //   builders: {
          //     TargetPlatform.android: CustomPageTransitionBuilder(),
          //     TargetPlatform.iOS: CustomPageTransitionBuilder(),
          //   },
          // ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: Root.routeName, //!
        routes: {
          Root.routeName: (ctx) => const Root(),
          AdminDashboard.routeName: (ctx) => AdminDashboard(),
          DriverDashboardScreen.routeName: (ctx) => DriverDashboardScreen(),
          CheckInScreen.routeName: (ctx) => CheckInScreen(),
          CheckOutScreen.routeName: (ctx) => CheckOutScreen(),
          //  ***  //
          UploadReceiptScreen.routeName: (ctx) => UploadReceiptScreen(),
          //  ***  //
          ReportList.routeName: (ctx) => ReportList(),
          ReceiptReview.routeName: (ctx) => ReceiptReview(),
          ReceiptReport.routeName: (ctx) => ReceiptReport(),
          ExpiryReport.routeName: (ctx) => ExpiryReport(),
          ExpiryList.routeName: (ctx) => ExpiryList(),
          //  ***  //
          DriverList.routeName: (ctx) => DriverList(),
          AddDriver.routeName: (ctx) => AddDriver(),
          DriverReceiptsScreen.routeName: (ctx) => DriverReceiptsScreen(),
          //  ***  //
          VehicleList.routeName: (ctx) => VehicleList(),
          AddVehicle.routeName: (ctx) => AddVehicle(),
        },
      ),
    );
  }
}
