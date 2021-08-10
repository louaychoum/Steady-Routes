import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/expiry_list_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/dropdown_search.dart';

class ExpiryInfo extends StatefulWidget {
  @override
  _ExpiryInfoState createState() => _ExpiryInfoState();
}

class _ExpiryInfoState extends State<ExpiryInfo> {
  final _formKey = GlobalKey<FormState>();
  String? /*late*/ _typeController;
  String? /*late*/ _drivers;
  int? /*late*/ _monthController;
  bool _isLoading = false;
  late String courierId;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final String jwt = auth.user.token;
    courierId = auth.courier?.id ?? '';
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Consumer<SteadyApiService>(
            builder: (context, api, child) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropDownSearch(
                      name: 'Report Type',
                      savedValue: (value) => setState(() {
                        _typeController = value.toString();
                      }),
                      items: kExReportDropDownItems,
                    ),
                    DropDownSearch(
                      name: 'Months Remaining',
                      savedValue: (value) {
                        if (value != null) {
                          setState(() {
                            _monthController = int.tryParse(value);
                          });
                        }
                      },
                      items: kMonthCountDropDownItems
                          .map(
                            (e) => e.toString(),
                          )
                          .toList(),
                    ),
                    DashboardButton(
                      'Submit',
                      () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        // if (_formKey.currentState!.validate()) {
                        if (_formKey.currentState != null) {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              if (_typeController != null) {
                                api.receiptsService
                                    .fetchExpiryReports(
                                  jwt,
                                  _typeController ?? '',
                                  _monthController ?? 0,
                                  courierId,
                                )
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }).whenComplete(
                                  () =>
                                      NavigationService.navigateToWithArguments(
                                    ExpiryList.routeName,
                                    _typeController ?? '',
                                  ),
                                );
                              }
                            } catch (error) {
                              await showDialog<void>(
                                context: NavigationService
                                    .navigatorKey.currentContext!,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('An error has occured!'),
                                  content: Text(
                                    error.toString(),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Ok'),
                                    )
                                  ],
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }
}
