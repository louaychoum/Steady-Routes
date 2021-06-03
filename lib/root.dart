import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/pages/adminDashBoardScreen/admin_dashboard_screen.dart';
import 'package:steadyroutes/pages/auth_screen.dart';
import 'package:steadyroutes/pages/driverDashBoardScreen/driver_dashboard_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';

import 'pages/driverDashBoardScreen/driver_dashboard_screen.dart';

class Root extends StatefulWidget {
  static const routeName = '/';
  const Root();

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, auth, child) {
      switch (auth.status) {
        case AuthStatus.notDetermined:
          return buildWaitingScreen();

        case AuthStatus.notLoggedIn:
          return AuthScreen();

        case AuthStatus.adminLoggedIn:
          return AdminDashboard(); //!

        case AuthStatus.driverLoggedIn:
          return DriverDashboardScreen();

        default:
          return buildWaitingScreen();
      }
    });
  }
}
