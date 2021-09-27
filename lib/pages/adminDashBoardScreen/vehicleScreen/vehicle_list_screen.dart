import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/vehicleScreen/add_vehicle_screen.dart';
import 'package:steadyroutes/widgets/vehicles_listview.dart';

class VehicleList extends StatelessWidget {
  static const routeName = '/vehicle-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            iconSize: 40,
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () => Navigator.of(context).pushReplacementNamed(
              AddVehicle.routeName,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicles List',
              style: kTextTitleStyle,
            ),
            const Divider(),
            Expanded(
              child: VehiclesListView(),
            ),
          ],
        ),
      ),
    );
  }
}
