import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:steadyroutes/helpers/geolocator.dart';
import 'package:steadyroutes/screens/driverDashBoardScreen/driver_dashboard_screen.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/widgets/mall_dropdown.dart';

class CheckInForm extends StatefulWidget {
  @override
  _CheckInFormState createState() => _CheckInFormState();
}

class _CheckInFormState extends State<CheckInForm> {
  late DateTime now;
  late String selectedValue;
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

  List<String> mallData = ['Mall1', 'Mall2'];
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(
            flex: 4,
          ),
          MallDropdown(
            (newVal) {
              selectedValue = newVal!;
            },
          ),
          const Spacer(),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState != null) {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    now = DateTime.now();
                    final String convertedDateTime =
                        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}-${now.minute.toString()}";
                    try {
                      final Position position = await determinePosition();
                      //Todo handle errors
                      _showMyDialog(position, selectedValue, convertedDateTime);
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
                            content:
                                const Text('Please enable location services'),
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
              child: const Text('Check In'),
            ),
          const Spacer(
            flex: 4,
          )
        ],
      ),
    );
  }
}
