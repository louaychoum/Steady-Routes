import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/screens/adminDashBoardScreen/admin_dashboard_screen.dart';
import 'package:steadyroutes/screens/auth_screen.dart';
import 'package:steadyroutes/screens/driverDashBoardScreen/driver_dashboard_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';

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
          break;
        case AuthStatus.notLoggedIn:
          return AdminDashboard();
          break;
        case AuthStatus.adminLoggedIn:
          return AdminDashboard(); //!
          break;
        case AuthStatus.driverLoggedIn:
          return AdminDashboard();
          break;
        default:
          return buildWaitingScreen();
      }
    });
  }
}
