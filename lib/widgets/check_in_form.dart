import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/geolocator.dart';
import 'package:steadyroutes/models/location.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/error_dialog.dart';
import 'package:steadyroutes/widgets/mall_dropdown.dart';
import 'package:steadyroutes/widgets/operation_dialog.dart';

class CheckInForm extends StatefulWidget {
  @override
  _CheckInFormState createState() => _CheckInFormState();
}

class _CheckInFormState extends State<CheckInForm> {
  late DateTime now;
  late Position position;
  Location? selectedLocation;
  late String jwt;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SteadyApiService>(
      builder: (context, api, child) {
        final auth = Provider.of<AuthService>(context, listen: false);
        jwt = auth.user.token;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(
                flex: 4,
              ),
              MallDropDown(
                jwt: jwt,
                api: api,
                savedValue: (Location? value) {
                  selectedLocation = value;
                },
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                DashboardButton(
                  'Check In',
                  () async {
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState != null) {
                        final isValid = _formKey.currentState?.validate();
                        if (isValid != null && !isValid) return;
                        _formKey.currentState?.save();
                        now = DateTime.now();
                        final String convertedDateTime =
                            "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}-${now.minute.toString()}";
                        setState(
                          () => isLoading = true,
                        );
                        try {
                          position = await determinePosition();
                          final addedCheck =
                              await api.attendanceService.addAttendance(
                            action: 'checkin',
                            date: now.toIso8601String(),
                            driver: auth.driver,
                            locationId: selectedLocation?.id,
                            lat: position.latitude,
                            long: position.longitude,
                            token: jwt,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          if (addedCheck != null && addedCheck.isNotEmpty) {
                            throw addedCheck;
                          }
                          showMyDialog(
                            context: context,
                            message:
                                'Checked In At ${position.latitude} , ${position.longitude}\nMall: ${selectedLocation?.address}\nAt time: $convertedDateTime',
                          );
//Todo handle errors
                        } catch (error) {
                          setState(() {
                            isLoading = false;
                          });
                          if (error == 'LOCATION_NOT_ENABLED') {
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
                          } else {
                            await buildErrorDialog(error);
                          }
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
