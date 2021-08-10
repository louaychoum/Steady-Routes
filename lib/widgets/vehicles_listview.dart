import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/pages/adminDashboardScreen/vehicleScreen/add_vehicle_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
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
    return Consumer<SteadyApiService>(
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
                    final vehicle = vehiclesList[index];
                    return Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          // final deletedVehicle = vehiclesList.removeAt(index);
                          final deletedVehicle = vehicle;
                          api.vehiclesService.deleteVehicle(
                            jwt,
                            vehicle.id ?? '',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${vehicle.name} was deleted"),
                              // action: SnackBarAction(
                              //   label: 'Undo',
                              //   onPressed: () => setState(
                              //     () =>
                              //         driversList.insert(index, deletedDriver),
                              //   ),
                              // ),
                            ),
                          );
                        });
                        WidgetsBinding.instance?.addPostFrameCallback(
                          (_) => _refreshKey.currentState?.show(),
                        );
                      },
                      confirmDismiss: (direction) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you wish to delete this driver?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("DELETE"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      key: UniqueKey(),
                      child: ListTile(
                        title: Text(vehicle.name),
                        trailing: Text(vehicle.plateNumber),
                        onTap: () => NavigationService.navigateToWithArguments(
                          AddVehicle.routeName,
                          api.vehiclesService.findById(vehicle.id ?? ''),
                        )?.then(
                          (value) =>
                              WidgetsBinding.instance?.addPostFrameCallback(
                            (_) => _refreshKey.currentState?.show(),
                          ),
                        ),
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
