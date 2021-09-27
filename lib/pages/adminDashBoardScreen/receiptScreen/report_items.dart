import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/services/auth_service.dart';

import 'package:steadyroutes/services/steady_api_service.dart';

class ReportItems extends StatefulWidget {
  final String selectedDriver;

  const ReportItems(this.selectedDriver);

  @override
  _ReportItemsState createState() => _ReportItemsState();
}

class _ReportItemsState extends State<ReportItems> {
  late String courierId;
  bool isInit = false;

  // Driver matchdriversId(List reportedDriverId, List driverId) {
  //   if (reportedDriverId.any((item) => driverId.contains(item))) {
  //     for (var reports in reportedDriverId) {
  //       print('reports $reports');
  //     }
  //     // Lists have at least one common element
  //   } else {
  //     // Lists DON'T have any common element
  //   }
  //   return;
  // }
  @override
  void initState() {
    super.initState();
    isInit = true;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final String jwt = auth.user.token;
    final selectedDriver = widget.selectedDriver;
    courierId = auth.courier?.id ?? '';
    final List<Driver> driverIdsList = [];

    return Consumer<SteadyApiService>(
      builder: (context, api, child) {
        // if (isInit) {
        //   api.driversService.fetchDrivers(jwt, courierId);
        //   isInit = false;
        // }
        //todo return driver names of the given driver Ids
        final reportItems = api.ledgerService.ledgers;
        final driversReport = api.driversService.drivers;
        return reportItems.isNotEmpty
            ? ListView.builder(
                itemCount: reportItems.length,
                itemBuilder: (context, index) {
                  final report = reportItems[index];
                  for (final Driver driver in driversReport) {
                    if (driver.name == selectedDriver) {
                      driverIdsList.add(driver);
                    }
                  }
                  final driver = driverIdsList[index];
                  return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      leading: Text(
                        dateFormat.format(
                          report.date!,
                        ),
                      ),
                      trailing: Text(
                        report.action,
                      ),
                      title: Text(driver.name),
                      onTap: () {}
                      //  Navigator.of(context).pushNamed(
                      //   DriverReceiptsScreen.routeName,
                      //   arguments: DriverReceiptsArguments(
                      //     driver,
                      //   ),
                      // ),
                      );
                },
              )
            : const Center(
                child: Text(
                  'No reports available...',
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }
}
