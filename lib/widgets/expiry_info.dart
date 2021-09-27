import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/expiry_list_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/dropdown_search.dart';
import 'package:steadyroutes/widgets/error_dialog.dart';

class ExpiryInfo extends StatefulWidget {
  @override
  _ExpiryInfoState createState() => _ExpiryInfoState();
}

class _ExpiryInfoState extends State<ExpiryInfo> {
  final _formKey = GlobalKey<FormState>();
  String? _typeController;
  String? _category;
  int? _monthController;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final String jwt = auth.user.token;
    final String courierId = auth.courier?.id ?? '';
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
                        if (_typeController == 'registration' ||
                            _typeController == 'license') {
                          _category = 'vehicles';
                        } else {
                          _category = 'drivers';
                        }
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
                                  _category ?? '',
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
                              await buildErrorDialog(error);
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
