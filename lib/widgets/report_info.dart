import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/report_list_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/default_textfield.dart';
import 'package:steadyroutes/widgets/dropdown_search.dart';
import 'package:steadyroutes/widgets/error_dialog.dart';

class ReportInfo extends StatefulWidget {
  @override
  _ReportInfoState createState() => _ReportInfoState();
}

class _ReportInfoState extends State<ReportInfo> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDriver;
  String? selectedVehicle;
  bool _isLoading = false;
  late String jwt;
  late String courierId;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );
  DateTimeRange? selectedRange;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(
    BuildContext context,
  ) async {
    // if (Platform.isAndroid) {

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return SingleChildScrollView(
          child: Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xFFF44336),
            ),
            child: child ?? const SizedBox(),
          ),
        );
      },
    );
    // } else {
    //todo
    // picked = await showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return SizedBox(
    //       height: MediaQuery.of(context).copyWith().size.height / 3,
    //       child: CupertinoDatePicker(
    //         onDateTimeChanged: (value) {
    //           setState(() {
    //             selectedDate = value;
    //             final String dateSlug =
    //                 "${value.year.toString()}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}";
    //             controller.text = dateSlug;
    //           });
    //         },
    //         mode: CupertinoDatePickerMode.date,
    //       ),
    //     );
    //   },
    // );
    // }
    if (picked != null) {
      setState(() {
        selectedRange = picked;
        final startDate = picked.start;
        final endDate = picked.end;
        selectedDate = picked.start;
        final String startDateSlug =
            "${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}/${startDate.year.toString()}";
        final String endDateSlug =
            "${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year.toString()}";
        _fromDateController.text = startDateSlug;
        _toDateController.text = endDateSlug;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SteadyApiService>(
      builder: (context, api, child) {
        final auth = Provider.of<AuthService>(context, listen: false);
        jwt = auth.user.token;
        courierId = auth.courier?.id ?? '';
        return Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              DropDownSearch(
                name: 'Driver',
                savedValue: (value) => selectedDriver = value,
                onFind: (_) async {
                  await api.driversService.fetchDrivers(
                    jwt,
                    courierId,
                  );
                  return api.driversService.drivers
                      .map(
                        (item) => item.name,
                      )
                      .toList();
                },
              ),
              DropDownSearch(
                name: 'Vehicle',
                savedValue: (value) => selectedVehicle = value,
                onFind: (_) async {
                  await api.vehiclesService.fetchVehicles(
                    jwt,
                    courierId,
                  );
                  return api.vehiclesService.vehicles
                      .map(
                        (item) => item.name,
                      )
                      .toList();
                },
              ),
              DefaultTextfield(
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'From Date',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_today_sharp,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () => _selectDate(
                      context,
                    ),
                  ),
                ),
                savedValue: (value) => null,
                mask: maskFormatter,
                controller: _fromDateController,
                keyboard: TextInputType.datetime,
              ),
              DefaultTextfield(
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'To Date',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_today_sharp,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () => _selectDate(
                      context,
                    ),
                  ),
                ),
                savedValue: (value) => null,
                mask: maskFormatter,
                controller: _toDateController,
                keyboard: TextInputType.datetime,
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                DashboardButton(
                  'Submit',
                  () async {
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          api.ledgerService
                              .fetchLedger(
                            jwt,
                          )
                              .then((value) {
                            if (value) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }).whenComplete(() {
                            setState(() {
                              _isLoading = false;
                            });
                            NavigationService.navigateToWithArguments(
                              ReportList.routeName,
                              [api.ledgerService.ledgers, selectedDriver],
                            );
                          });
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
