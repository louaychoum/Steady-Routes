import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/screens/adminDashBoardScreen/driverScreen/driver_receipts_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/steady_api_service.dart';

class DriversListView extends StatefulWidget {
  //!change to stateless
  @override
  _DriversListViewState createState() => _DriversListViewState();
}

class _DriversListViewState extends State<DriversListView> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  late String jwt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _refreshKey.currentState!.show());
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<DriversService>(context).fetchDrivers().then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final driversData = Provider.of<DriversService>(context);
    // final drivers = driversData.drivers;

    return
        // _isLoading
        //     ? const Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     :
        ///!!!
        // drivers.isEmpty
        //     ? const Center(
        //         child: Text('No drivers added yetpackage:steadyroutes.'),
        //       )
        //     :
        Consumer<SteadyApiService>(
      builder: (context, api, child) {
        return RefreshIndicator(
          key: _refreshKey,
          onRefresh: () {
            jwt = Provider.of<AuthService>(context, listen: false).user.token;
            return api.driversService.fetchDrivers(jwt);
          },
          child: ListView.builder(
              itemCount: api.driversService.drivers.length,
              itemBuilder: (context, index) {
                final driver = api.driversService.drivers[index];
                return ListTile(
                  title: Text(driver.name),
                  trailing: Text(
                    driver.user?.email ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                    DriverReceiptsScreen.routeName,
                    arguments: DriverReceiptsArguments(
                      driver,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
