import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:steadyroutes/pages/add_new_user.dart';

import 'package:steadyroutes/pages/adminDashBoardScreen/admin_dashboard_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/driverScreen/add_driver_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/driverScreen/driver_list_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/driverScreen/driver_receipts_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/expiry_list_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/expiry_report_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/receipt_report_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/receipt_review_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/report_list_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/vehicleScreen/add_vehicle_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/vehicleScreen/vehicle_list_screen.dart';
import 'package:steadyroutes/pages/driverDashBoardScreen/check_in_screen.dart';
import 'package:steadyroutes/pages/driverDashBoardScreen/check_out_screen.dart';
import 'package:steadyroutes/pages/driverDashBoardScreen/driver_dashboard_screen.dart';
import 'package:steadyroutes/pages/driverDashBoardScreen/upload_receipt_screen.dart';
import 'package:steadyroutes/root.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/services/web_auth_service.dart';

//!android:usesCleartextTraffic="true"  Remove in android manifest
void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen(
    (record) {
      print(
        '${record.sequenceNumber}-[${record.level.name}]: ${record.time.toLocal()}, ${record.loggerName}, ${record.message}',
        //  Error: ${record.error ?? ''}, StackTrace: ${record.stackTrace ?? ''}',
      );
    },
    onError: (e) => print('error $e'),
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
    const primaryColor = Color(0xfff23340);
    const accentColor = Color(0xff448F83);

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
        // home: s(),
        theme: ThemeData(
          fontFamily: GoogleFonts.lato().fontFamily,
          dividerColor: primaryColor,
          fixTextFieldOutlineLabel: true,
          textTheme:
              GoogleFonts.latoTextTheme(Theme.of(context).textTheme).copyWith(),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: accentColor,
            ),
          ),
          primaryColor: primaryColor,
          accentColor: accentColor,
          appBarTheme: const AppBarTheme(
            actionsIconTheme: IconThemeData(
              color: primaryColor,
            ),
            iconTheme: IconThemeData(
              color: primaryColor,
            ),
            backgroundColor: Color(0xffffffff),
            elevation: 0,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: GoogleFonts.bungee(
                fontSize: 24,
                letterSpacing: 1.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              primary: primaryColor,
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
          // *** //
          AddUser.routeName: (ctx) => AddUser(),
        },
      ),
    );
  }
}
