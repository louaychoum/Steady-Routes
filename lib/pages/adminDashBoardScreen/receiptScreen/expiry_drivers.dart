import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steadyroutes/helpers/constants.dart';

import 'package:steadyroutes/services/steady_api_service.dart';

class ExpiryDrivers extends StatefulWidget {
  final String? reportType;

  const ExpiryDrivers(
    this.reportType,
  );

  @override
  _ExpiryDriversState createState() => _ExpiryDriversState();
}

class _ExpiryDriversState extends State<ExpiryDrivers> {
  @override
  Widget build(BuildContext context) {
    String selectedReport = '';

    return Consumer<SteadyApiService>(
      builder: (context, api, child) {
        final driversList = api.receiptsService.driversReport;
        return driversList.isNotEmpty
            ? ListView.builder(
                itemCount: driversList.length,
                itemBuilder: (context, index) {
                  final driver = driversList[index];
                  if (widget.reportType == 'drivinglicense') {
                    selectedReport = dateFormat.format(
                      driver.licenseExpiryDate,
                    );
                  } else if (widget.reportType == 'visa') {
                    selectedReport = dateFormat.format(
                      driver.visaExDate,
                    );
                  } else if (widget.reportType == 'passport') {
                    selectedReport = dateFormat.format(
                      driver.passportExDate,
                    );
                  }
                  return ListTile(
                    title: Text(
                      driver.name,
                    ),
                    trailing: Text(
                      selectedReport,
                    ),
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
