import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/screens/driverDashboardScreen/check_in_screen.dart';
import 'package:steadyroutes/screens/driverDashBoardScreen/check_out_screen.dart';
import 'package:steadyroutes/screens/driverDashBoardScreen/upload_receipt_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';

class DriverDashboardScreen extends StatelessWidget {
  static const routeName = '/driver-dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 3,
            ),
            DashboardButton(
              'Upload Receipt',
              () => Navigator.of(context).pushNamed(
                UploadReceiptScreen.routeName,
              ),
            ),
            const Spacer(),
            DashboardButton(
              'Check In',
              () => Navigator.of(context).pushNamed(
                CheckInScreen.routeName,
              ),
            ),
            const Spacer(),
            DashboardButton(
              'Check Out',
              () => Navigator.of(context).pushNamed(
                CheckOutScreen.routeName,
              ),
            ),
            const Spacer(),
            DashboardButton(
              'Log Out',
              () => Provider.of<AuthService>(context, listen: false).signOut(),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
