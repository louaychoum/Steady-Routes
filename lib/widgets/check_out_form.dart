import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/helpers/geolocator.dart';
import 'package:steadyroutes/models/location.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/default_textfield.dart';
import 'package:steadyroutes/widgets/error_dialog.dart';
import 'package:steadyroutes/widgets/mall_dropdown.dart';
import 'package:steadyroutes/widgets/operation_dialog.dart';

class CheckOutForm extends StatefulWidget {
  @override
  _CheckOutFormState createState() => _CheckOutFormState();
}

class _CheckOutFormState extends State<CheckOutForm> {
  late Position position;
  late DateTime now;
  Location? selectedLocation;
  double savedAmount = 0.0;
  late String jwt;
  bool isLoading = false;
  // final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
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
              DefaultTextfield(
                //todo accept empty == 0
                keyboard: TextInputType.number,
                initialVal: savedAmount,
                // controller: _controller,
                decoration: kTextFieldDecoration.copyWith(
                  prefixText: 'AED ',
                  labelText: 'Amount',
                ),
                savedValue: (value) {
                  if (value != null) {
                    savedAmount = double.tryParse(value) ?? 0;
                  }
                },
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                DashboardButton(
                  'Check Out',
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
                            action: 'checkout',
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
                                'Checked Out At Mall: ${selectedLocation?.address},\nWith Cash Amount Of: ${savedAmount == 0.0 ? 'Not Available' : savedAmount}\nAt time: $convertedDateTime',
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
              ),
            ],
          ),
        );
      },
    );
  }
}
