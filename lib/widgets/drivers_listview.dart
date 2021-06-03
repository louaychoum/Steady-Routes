import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/driver.dart';

import 'package:steadyroutes/pages/adminDashBoardScreen/driverScreen/driver_receipts_screen.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _refreshKey.currentState!.show());
  }

  Future<void> fetchDrivers(SteadyApiService api) {
    setState(() {
      isLoading = true;
    });
    return api.driversService.fetchDrivers(jwt).then(
      (value) {
        if (!value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to get drivers'),
              action: SnackBarAction(
                label: 'Try Again',
                onPressed: () => {
                  setState(() {
                    isLoading = true;
                  }),
                  api.driversService.fetchDrivers(jwt).whenComplete(
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
        final driversList = api.driversService.drivers;
        return RefreshIndicator(
          key: _refreshKey,
          onRefresh: () {
            jwt = Provider.of<AuthService>(context, listen: false).user.token;
            return fetchDrivers(api).whenComplete(() {
              setState(() {
                isLoading = false;
              });
            });
          },
          child: driversList.isNotEmpty
              ? ListView.builder(
                  itemCount: driversList.length,
                  itemBuilder: (context, index) {
                    final driver = driversList[index];
                    return Dismissible(
                      key: ValueKey<int>(index),
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          // final deletedDriver = driversList.removeAt(index);
                          final deletedDriver = driver;
                          api.driversService.deleteDriver(jwt, driver.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${driver.name} was deleted"),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () => setState(
                                  () =>
                                      driversList.insert(index, deletedDriver),
                                ),
                              ),
                            ),
                          );
                        });
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
                      child: ListTile(
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
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'No driver added yet...',
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => fetchDrivers(api).whenComplete(() {
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
