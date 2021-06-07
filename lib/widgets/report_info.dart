import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/report_list_screen.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/steady_api_service.dart';

class ReportInfo extends StatefulWidget {
  @override
  _ReportInfoState createState() => _ReportInfoState();
}

class _ReportInfoState extends State<ReportInfo> {
  final _formKey = GlobalKey<FormState>();
  late String selectedDriver;
  late String selectedVehicle;
  // bool isDriver = false;
  bool isLoading = false;
  late String jwt;
  late String courierId;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
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
        // api.vehiclesService.fetchVehicles('');
        print('build');
        //  api.driversService.fetchDrivers(
        //   jwt,
        //   courierId,
        // );
        final driverData = api.driversService.drivers;
        final vehicleData = api.vehiclesService.vehicles;
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: DropdownSearch<String>(
                    showAsSuffixIcons: true,
                    searchBoxDecoration: kTextFieldDecoration.copyWith(
                      labelText: 'Driver Name',
                      hintText: 'Search drivers',
                    ),
                    dropdownSearchDecoration: kTextFieldDecoration.copyWith(
                      labelText: 'Driver Name',
                      hintText: 'Choose a driver',
                    ),
                    showClearButton: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a driver';
                      }
                      return null;
                    },
                    mode: Mode.BOTTOM_SHEET,
                    emptyBuilder: (context, searchEntry) {
                      isLoading = true;
                      api.driversService
                          .fetchDrivers(
                            jwt,
                            courierId,
                          ) 
                          .whenComplete(() => isLoading = false);
                      return isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const SizedBox();
                    },
                    showSearchBox: true,
                    items: driverData.map(
                      (item) {
                        return item.name;
                      },
                    ).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 20,
                  ),
                  child: DropdownSearch<String>(
                    showAsSuffixIcons: true,
                    searchBoxDecoration: kTextFieldDecoration.copyWith(
                      labelText: 'Vehicle Name',
                      hintText: 'Search vehicles',
                    ),
                    dropdownSearchDecoration: kTextFieldDecoration.copyWith(
                      labelText: 'Vehicle Name',
                      hintText: 'Choose a vehicle',
                    ),
                    showClearButton: true,
                    // validator: (value) {
                    //   if (value == null) {
                    //     return 'Please select a vehicle';
                    //   }
                    //   return null;
                    // },
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    items: vehicleData.map((item) {
                      return item.name;
                    }).toList(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: TextFormField(
                    inputFormatters: [maskFormatter],
                    controller: _fromDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'From Date',
                      hintText: '',
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_sharp,
                        ),
                        onPressed: () => _selectDate(
                          context,
                        ),
                      ),
                    ),

                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length < 10 ||
                          value.length > 10) {
                        return 'Please enter a valid Date';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: TextFormField(
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.datetime,
                    controller: _toDateController,
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'To Date',
                      hintText: '',
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_sharp,
                        ),
                        onPressed: () => _selectDate(
                          context,
                        ),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length < 10 ||
                          value.length > 10) {
                        return 'Please enter a valid Date';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      // !if (!isDriver) {
                      //   const snackBar = SnackBar(
                      //     content: Text('Please Select a Driver'),
                      //     duration: Duration(seconds: 1),
                      //     backgroundColor: Colors.red,
                      //   );
                      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // }

                      // Validate returns true if the form is valid, or false otherwise.
                      // if (_formKey.currentState!.validate()) {
                      if (_formKey.currentState != null) {
                        if (_formKey.currentState!.validate()) {
                          //!isdriver
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          /** 
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      */

                          Navigator.of(context).pushNamed(ReportList.routeName);
                        }
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
