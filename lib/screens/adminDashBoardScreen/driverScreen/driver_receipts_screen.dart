import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/widgets/receipts_listview.dart';

class DriverReceiptsArguments {
  final Driver driver;
  DriverReceiptsArguments(
    this.driver,
  );
}

class DriverReceiptsScreen extends StatelessWidget {
  static const routeName = '/driver-receipt';
  static late DriverReceiptsArguments? args;
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as DriverReceiptsArguments?;
    final loadedDriver = args!.driver;
    // final driverId = ModalRoute.of(context).settings.arguments as int;
    // final loadedDriver = driversService.findById(args.driver);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          loadedDriver.name,
          style: kTextTitleStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: ReceiptListView(loadedDriver),
      ),
    );
  }
}
