import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/default_textfield.dart';
import 'package:steadyroutes/widgets/dropdown_search.dart';

class DriverInfo extends StatefulWidget {
  const DriverInfo({
    Driver? driver,
  }) : _driver = driver;
  final Driver? _driver;
  @override
  _DriverInfoState createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {
  final _formKey = GlobalKey<FormState>();
  final _licenseDateController = TextEditingController();
  final _passportDateController = TextEditingController();
  final _visaDateController = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  DateTime selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isInit = true;
  String? driverId;
  late String courierId;

  Driver _editedDriver = Driver(
    id: '',
    name: '',
    email: '',
    password: '',
    company: '',
    drivingLicense: '',
    drivingLicenseExDate: '',
    passportExDate: '',
    passportNumber: '',
    plateNumber: '',
    visaExDate: '',
    visaNumber: 0,
    phone: 0,
    user: null,
    courierId: '',
  );

  Map<String, dynamic> _initValues = {
    'name': '',
    'email': '',
    'password': '',
    'licenseNo': '',
    'phone': '',
    'courier': '',
    'plateNumber': '',
    'drivingLicenseExDate': '',
    'company': '',
    'passportNumber': '',
    'passportExDate': '',
    'visaNumber': '',
    'visaExDate': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      widget._driver != null ? driverId = widget._driver?.id : driverId = null;
      if (driverId != null) {
        _editedDriver = widget._driver!;
        _initValues = {
          'name': _editedDriver.name,
          'licenseNo': _editedDriver.drivingLicense,
          'phone': _editedDriver.phone,
          'email': _editedDriver.email,
          'password': _editedDriver.password,
          // 'courier': _editedDriver.courier,
          // 'rtaExDate': '',
          // 'rtaNumber': _editedDriver.rtaNumber.toString(),
        };
        _licenseDateController.text = _editedDriver.drivingLicenseExDate;
        _passportDateController.text = _editedDriver.passportExDate;
        _visaDateController.text = _editedDriver.visaExDate;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(
        () {
          selectedDate = picked;
          final String startDateSlug =
              "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString()}";
          controller.text = startDateSlug;
          selectedDate = DateTime.now();
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _licenseDateController.dispose();
    _passportDateController.dispose();
    _visaDateController.dispose();
  }

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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DefaultTextfield(
                        initialVal: _initValues['name'],
                        savedValue: (newValue) {
                          _editedDriver =
                              _editedDriver.copyWith(name: newValue);
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Driver Name',
                        ),
                      ),
                      DefaultTextfield(
                        initialVal: _initValues['email'],
                        savedValue: (newValue) {
                          _editedDriver = _editedDriver.copyWith(
                            email: newValue,
                          );
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Email',
                        ),
                      ),
                      DefaultTextfield(
                        initialVal: _initValues['password'],
                        savedValue: (newValue) {
                          _editedDriver = _editedDriver.copyWith(
                            password: newValue,
                          );
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Password',
                        ),
                      ),
                      DropDownSearch(
                        jwt: jwt,
                        name: 'Vehicle',
                        savedValue: (value) => null,
                        // String? selectedVehicle;
                        // selectedVehicle = value,
                        onFind: (_) async {
                          await api.vehiclesService.fetchVehicles(
                            jwt,
                            courierId, //courierId,
                          );
                          return api.vehiclesService.vehicles
                              .map(
                                (item) => item.name,
                              )
                              .toList();
                        },
                      ),
                      // DefaultTextfield(
                      //   savedValue: (newValue) {
                      //     _editedDriver =
                      //         _editedDriver.copyWith(plateNumber: newValue);
                      //   },
                      //   decoration: kTextFieldDecoration.copyWith(
                      //     labelText: 'Vehicle Plate Number',
                      //   ),
                      // ), //todo change to dropdown
                      DefaultTextfield(
                        initialVal: _initValues['phone'],
                        keyboard: TextInputType.number,
                        savedValue: (newValue) {
                          _editedDriver = _editedDriver.copyWith(
                            phone: int.tryParse(newValue ?? ''),
                          );
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Phone Number',
                        ),
                      ),
                      DefaultTextfield(
                        initialVal: _initValues['licenseNo'],
                        keyboard: TextInputType.number,
                        savedValue: (newValue) {
                          _editedDriver = _editedDriver.copyWith(
                            drivingLicense: newValue,
                          );
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Driving License',
                        ),
                      ),
                      DefaultTextfield(
                        savedValue: (newValue) {
                          _editedDriver = _editedDriver.copyWith(
                              drivingLicenseExDate: newValue);
                        },
                        mask: maskFormatter,
                        controller: _licenseDateController,
                        keyboard: TextInputType.datetime,
                        decoration: kTextFieldDecoration.copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_sharp,
                            ),
                            onPressed: () => _selectDate(
                              context,
                              _licenseDateController,
                            ),
                          ),
                          labelText: 'Driving License Expiry Date',
                          suffix: const Text('DD/MM/YYYY'),
                        ),
                      ),
                      DefaultTextfield(
                        //!change to dropdown
                        savedValue: (newValue) {
                          _editedDriver =
                              _editedDriver.copyWith(company: newValue);
                        },

                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Company',
                        ),
                      ),
                      DefaultTextfield(
                        savedValue: (newValue) {
                          _editedDriver =
                              _editedDriver.copyWith(passportNumber: newValue);
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Passport Number',
                        ),
                      ),
                      DefaultTextfield(
                        savedValue: (newValue) {
                          _editedDriver =
                              _editedDriver.copyWith(passportExDate: newValue);
                        },
                        mask: maskFormatter,
                        keyboard: TextInputType.datetime,
                        controller: _passportDateController,
                        decoration: kTextFieldDecoration.copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_sharp,
                            ),
                            onPressed: () => _selectDate(
                              context,
                              _passportDateController,
                            ),
                          ),
                          labelText: 'Passport Expiry Date',
                          suffix: const Text('DD/MM/YYYY'),
                        ),
                      ),
                      DefaultTextfield(
                        keyboard: TextInputType.number,
                        savedValue: (newValue) {
                          _editedDriver = _editedDriver.copyWith(
                            visaNumber: int.tryParse(newValue!),
                          );
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Visa Number',
                        ),
                      ),
                      DefaultTextfield(
                        savedValue: (newValue) {
                          _editedDriver =
                              _editedDriver.copyWith(visaExDate: newValue);
                        },
                        mask: maskFormatter,
                        keyboard: TextInputType.datetime,
                        controller: _visaDateController,
                        decoration: kTextFieldDecoration.copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_sharp,
                            ),
                            onPressed: () => _selectDate(
                              context,
                              _visaDateController,
                            ),
                          ),
                          labelText: 'Visa Expiry Date',
                          suffix: const Text('DD/MM/YYYY'),
                        ),
                      ),
                      if (_isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      else
                        DashboardButton(
                          'Submit',
                          () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            // if (_formKey.currentState!.validate()) {
                            //
                            if (_formKey.currentState != null) {
                              final isValid = _formKey.currentState?.validate();
                              if (isValid != null && !isValid) return;
                              _formKey.currentState?.save();
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                final bool addedDriver = await api
                                    .driversService
                                    .addDriver(jwt, courierId, _editedDriver);
                                if (!addedDriver) {
                                  throw 'Try Logging out and Sign In again';
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
                              setState(() {
                                _isLoading = false;
                              });
                              NavigationService.goBack(); //
                              //
                              //
                              //*if(editedpr.id != null)
                              // Provider.of<Products>(ctx, llisten: false).updateProduct(editedpr);
                              //* else
                              // Provider.of<Products>(ctx, llisten: false).aaProduct(editedpr);
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                            }
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
