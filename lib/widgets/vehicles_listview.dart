import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/screens/adminDashboardScreen/vehicleScreen/add_vehicle_screen.dart';
import 'package:steadyroutes/services/steady_api_service.dart';

class VehiclesListView extends StatefulWidget {
  @override
  _VehiclesListViewState createState() => _VehiclesListViewState();
}

class _VehiclesListViewState extends State<VehiclesListView> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  String jwt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshKey.currentState.show());
  }
  // var _isInit = true;
  // var _isLoading = false;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Vehicles>(context).fetchVehicles().then((_) {
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
    // final vehicleData = Provider.of<Vehicles>(context);
    // final vehicles = vehicleData.vehicles;

    return
        // _isLoading
        //     ? const Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : vehicles.isEmpty
        //         ? const Center(
        //             child: Text('No vehicles added yetpackage:steadyroutes.'),
        //           )
        //         :
        Consumer<SteadyApiService>(
      builder: (context, api, child) {
        return RefreshIndicator(
          key: _refreshKey,
          onRefresh: () {
            // jwt = Provider.of<AuthService>(context, listen: false).user.jwt;
            jwt = '';
            return api.vehiclesService.fetchVehicles(jwt);
          },
          child: ListView.builder(
            itemCount: api.vehiclesService.vehicles == null
                ? 0
                : api.vehiclesService.vehicles.length,
            itemBuilder: (context, index) {
              final vehicles = api.vehiclesService.vehicles[index];
              return ListTile(
                title: Text(vehicles.name),
                trailing: Text(vehicles.plateNumber),
                onTap: () => Navigator.of(context).pushNamed(
                  AddVehicle.routeName,
                  arguments: api.vehiclesService.findById(vehicles.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
