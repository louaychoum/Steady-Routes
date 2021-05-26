import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/vehicle.dart';
import 'package:steadyroutes/widgets/vehicle_info.dart';

class AddVehicle extends StatelessWidget {
  static const routeName = '/add-vehicle';

  @override
  Widget build(BuildContext context) {
    final loadedVehicles = ModalRoute.of(context).settings.arguments as Vehicle;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (loadedVehicles == null)
              const Text(
                'New Vehicle',
                style: kTextTitleStyle,
              )
            else
              Text(
                loadedVehicles.name,
                style: kTextTitleStyle,
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(5),
                child: VehicleInfo(
                  vehicle: loadedVehicles,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
