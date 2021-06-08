import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/pages/adminDashboardScreen/vehicleScreen/add_vehicle_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/steady_api_service.dart';

class VehiclesListView extends StatefulWidget {
  @override
  _VehiclesListViewState createState() => _VehiclesListViewState();
}

class _VehiclesListViewState extends State<VehiclesListView> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  late String jwt;
  late String courierId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _refreshKey.currentState!.show());
  }

  Future<void> fetchVehicles(SteadyApiService api) {
    setState(() {
      isLoading = true;
    });
    return api.vehiclesService
        .fetchVehicles(
      jwt,
      '',
    )
        .then(
      (value) {
        if (!value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to get vehicles'),
              action: SnackBarAction(
                label: 'Try Again',
                onPressed: () => {
                  setState(() {
                    isLoading = true;
                  }),
                  fetchVehicles(api).whenComplete(
                    () => {
                      setState(() {
                        isLoading = false;
                      }),
                    },
                  ),
                },
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        final auth = Provider.of<AuthService>(context, listen: false);
        final vehiclesList = api.vehiclesService.vehicles;
        return RefreshIndicator(
          key: _refreshKey,
          onRefresh: () {
            jwt = auth.user.token;
            //! courierId = auth.courier?.id ?? '';
            return fetchVehicles(api).whenComplete(() => {
                  if (mounted)
                    {
                      setState(() {
                        isLoading = false;
                      }),
                    },
                });
          },
          child: vehiclesList.isNotEmpty
              ? ListView.builder(
                  itemCount: vehiclesList.length,
                  itemBuilder: (context, index) {
                    final vehicles = vehiclesList[index];
                    return ListTile(
                      title: Text(vehicles.name),
                      trailing: Text(vehicles.plateNumber),
                      onTap: () => Navigator.of(context).pushNamed(
                        AddVehicle.routeName,
                        arguments:
                            api.vehiclesService.findById(vehicles.id ?? ''),
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'No vehicles added yet...',
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => fetchVehicles(api).whenComplete(() {
                        setState(() {
                          isLoading = false;
                        });
                      }),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Refresh'),
                    )
                  ],
                ),
        );
      },
    );
  }
}
