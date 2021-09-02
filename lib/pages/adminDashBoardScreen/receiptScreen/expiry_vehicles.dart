import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/services/steady_api_service.dart';

class ExpiryVehicle extends StatefulWidget {
  @override
  _ExpiryVehicleState createState() => _ExpiryVehicleState();
}

class _ExpiryVehicleState extends State<ExpiryVehicle> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SteadyApiService>(
      builder: (context, api, child) {
        final vehiclesList = api.receiptsService.vehiclesReport;
        return vehiclesList.isNotEmpty
            ? ListView.builder(
                itemCount: vehiclesList.length,
                itemBuilder: (context, index) {
                  final vehicle = vehiclesList[index];
                  return ListTile(
                    title: Text(vehicle.name),
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
                  'No vehicles available...',
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }
}
