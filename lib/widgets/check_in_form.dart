import 'dart:async';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:steadyroutes/helpers/constants.dart';

import 'package:steadyroutes/helpers/geolocator.dart';
import 'package:steadyroutes/models/location.dart';
import 'package:steadyroutes/pages/driverDashBoardScreen/driver_dashboard_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/dropdown_search.dart';
import 'package:steadyroutes/widgets/mall_dropdown.dart';

class CheckInForm extends StatefulWidget {
  @override
  _CheckInFormState createState() => _CheckInFormState();
}

class _CheckInFormState extends State<CheckInForm> {
  late DateTime now;
  late Location selectedLocation;
  late String jwt;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _showMyDialog(Position pos, String value, String time) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('\u{2705} Operation Successful'),
          content: Text(
            'Checked In At ${pos.latitude} , ${pos.longitude} \nMall: $value \nAt time: $time',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                NavigationService.popUntilRoot();
              },
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SteadyApiService>(
      builder: (context, api, child) {
        final auth = Provider.of<AuthService>(context, listen: false);
        jwt = auth.user.token;
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(
                flex: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: DropdownSearch<Location>(
                  onFind: (_) async {
                    await api.locationsService.fetchLocation(
                      jwt,
                    );
                    return api.locationsService.locations.map(
                      (item) {
                        return item;
                      },
                    ).toList();
                  },
                  itemAsString: (item) => item.address,
                  onChanged: (Location? picked) {
                    if (picked != null) {
                      selectedLocation = picked;
                    }
                  },
                  showAsSuffixIcons: true,
                  dropdownSearchDecoration: kTextFieldDecoration.copyWith(
                    labelText: 'Mall Name',
                    hintText: 'Choose a Mall',
                  ),
                  searchBoxDecoration: kTextFieldDecoration.copyWith(
                    labelText: 'Mall Name',
                    hintText: 'Search Malls',
                  ),
                  showClearButton: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Mall';
                    }
                    return null;
                  },
                  showSearchBox: true,
                ),
              ),
              // DropDownSearch(
              //   jwt: jwt,
              //   name: 'Mall',
              //   onFind: (_) async {
              //     await api.locationsService.fetchLocation(
              //       jwt,
              //     );
              //     return api.locationsService.locations.map(
              //       (item) {
              //         return item.address;
              //       },
              //     ).toList();
              //   },
              //   savedValue: (value) {
              //     print('value $value');
              //     selectedLocation = value.toString();
              //   },
              // ),
              const Spacer(),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                DashboardButton(
                  'Check In',
                  () async {
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.validate()) {
                        now = DateTime.now();
                        setState(
                          () => isLoading = true,
                        );
                        final String convertedDateTime =
                            "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}-${now.minute.toString()}";
                        try {
                          final Position position = await determinePosition();
                          await api.attendanceService
                              .addAttendance(
                                action: 'checkin',
                                date: now.toIso8601String(),
                                driver: auth.driver,
                                locationId: selectedLocation.id,
                                lat: position.latitude,
                                long: position.longitude,
                                token: jwt,
                              )
                              .whenComplete(
                                () => _showMyDialog(
                                  position,
                                  selectedLocation.address,
                                  convertedDateTime,
                                ),
                              );

                          //Todo handle errors

                          setState(() {
                            isLoading = false;
                          });
                        } on TimeoutException catch (e) {
                          setState(() {
                            isLoading = false;
                          });

                          debugPrint('timeout $e');
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          if (e == 'LOCATION_NOT_ENABLED') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Please enable location services'),
                                action: SnackBarAction(
                                  label: 'Enable Location',
                                  onPressed: () {
                                    Geolocator.openLocationSettings();
                                  },
                                ),
                              ),
                            );
                          }
                          debugPrint('error is $e');
                        }
                      }
                    }
                  },
                ),
              const Spacer(
                flex: 4,
              )
            ],
          ),
        );
      },
    );
  }
}
