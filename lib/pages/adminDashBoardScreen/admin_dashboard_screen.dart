import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steadyroutes/helpers/constants.dart';

import 'package:steadyroutes/pages/adminDashBoardScreen/driverScreen/driver_list_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/expiry_report_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/receipt_report_screen.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/vehicleScreen/vehicle_list_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';

class AdminDashboard extends StatelessWidget {
  static const routeName = '/admin';

  @override
  Widget build(BuildContext context) {
    print(
      'Courier id: ${Provider.of<AuthService>(context, listen: false).courier?.id}',
    );
    
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            'Hello ${Provider.of<AuthService>(context, listen: false).user.email}\n${Provider.of<AuthService>(context, listen: false).courier?.name}',
            style: kTextTitleStyle,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1, //3
            ),
            DashboardButton(
              'Drivers',
              () => Navigator.of(context).pushNamed(
                DriverList.routeName,
              ),
            ),
            const Spacer(),
            DashboardButton(
              'Vehicles',
              () => Navigator.of(context).pushNamed(
                VehicleList.routeName,
              ),
            ),
            const Spacer(),
            DashboardButton(
              'Receipts Report',
              () => Navigator.of(context).pushNamed(
                ReceiptReport.routeName,
              ),
            ),
            const Spacer(),
            DashboardButton(
              'Near Expiry Report',
              () => Navigator.of(context).pushNamed(
                ExpiryReport.routeName,
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
