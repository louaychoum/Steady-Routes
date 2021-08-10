import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/pages/adminDashBoardScreen/driverScreen/driver_receipts_screen.dart';
import 'package:steadyroutes/services/steady_api_service.dart';

class ExpiryDrivers extends StatefulWidget {
  @override
  _ExpiryDriversState createState() => _ExpiryDriversState();
}

class _ExpiryDriversState extends State<ExpiryDrivers> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SteadyApiService>(
      builder: (context, api, child) {
        final driversList = api.receiptsService.driversReport;
        return driversList.isNotEmpty
            ? ListView.builder(
                itemCount: driversList.length,
                itemBuilder: (context, index) {
                  final driver = driversList[index];
                  return ListTile(
                    title: Text(driver.name),
                    // onTap: () => Navigator.of(context).pushNamed(
                    //     DriverReceiptsScreen.routeName,
                    //     arguments: DriverReceiptsArguments(
                    //       driver,
                    //     ),
                    //   ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'No drivers available...',
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }
}
