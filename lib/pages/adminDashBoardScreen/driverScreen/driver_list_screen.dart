import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/driverScreen/add_driver_screen.dart';
import 'package:steadyroutes/widgets/drivers_listview.dart';

class DriverList extends StatelessWidget {
  static const routeName = '/driver-list';

  // final myProducts = List<String>.generate(20, (i) => 'Driver $i');

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
            onPressed: () =>
                Navigator.of(context).pushNamed(AddDriver.routeName),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Drivers List',
              style: kTextTitleStyle,
            ),
            const Divider(),
            Expanded(
              child: DriversListView(),
            ),
          ],
        ),
      ),
    );
  }
}
