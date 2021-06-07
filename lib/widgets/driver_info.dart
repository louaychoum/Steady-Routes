import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/courier.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/models/user.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/steady_api_service.dart';

class DriverInfo extends StatefulWidget {
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
  Courier? courier;

  Driver _editedDriver = Driver(
    id: '',
    name: '',
    company: '',
    drivingLicense: 0,
    drivingLicenseExDate: '',
    passportExDate: '',
    passportNumber: '',
    plateNumber: '',
    courier: null,
    visaExDate: '',
    visaNumber: 0,
    phone: 0,
    user: null,
  );

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
    courier = auth.courier;
    _editedDriver = _editedDriver.copyWith(
      courier: courier,
    );
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              onSaved: (newValue) {
                _editedDriver = _editedDriver.copyWith(name: newValue);
              },
              textInputAction: TextInputAction.next,
              decoration: kTextFieldDecoration.copyWith(
                labelText: 'Driver Name',
                hintText: '',
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              onSaved: (newValue) {
                // _editedDriver = _editedDriver.copyWith(email: newValue);
              },
              textInputAction: TextInputAction.next,
              decoration: kTextFieldDecoration.copyWith(
                labelText: 'Username',
                hintText: '',
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              onSaved: (newValue) {
                _editedDriver = _editedDriver.copyWith(plateNumber: newValue);
              },
              textInputAction: TextInputAction.next,
              decoration: kTextFieldDecoration.copyWith(
                labelText: 'Vehicle Plate Number',
                hintText: '',
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (newValue) {
                _editedDriver = _editedDriver.copyWith(
                  drivingLicense: int.tryParse(newValue!),
                );
              },
              textInputAction: TextInputAction.next,
              decoration: kTextFieldDecoration.copyWith(
                labelText: 'Driving License',
                hintText: '',
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              onSaved: (newValue) {
                _editedDriver =
                    _editedDriver.copyWith(drivingLicenseExDate: newValue);
              },
              inputFormatters: [maskFormatter],
              textInputAction: TextInputAction.next,
              controller: _licenseDateController,
              keyboardType: TextInputType.datetime,
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
                hintText: '',
                suffix: const Text('DD/MM/YYYY'),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                if (value.length != 10) {
                  return 'Make sure the date format is correct';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              //!change to dropdown
              onSaved: (newValue) {
                _editedDriver = _editedDriver.copyWith(company: newValue);
              },
              textInputAction: TextInputAction.next,
              decoration: kTextFieldDecoration.copyWith(
                labelText: 'Company',
                hintText: '',
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              onSaved: (newValue) {
                _editedDriver =
                    _editedDriver.copyWith(passportNumber: newValue);
              },
              textInputAction: TextInputAction.next,
              decoration: kTextFieldDecoration.copyWith(
                labelText: 'Passport Number',
                hintText: '',
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              onSaved: (newValue) {
                _editedDriver =
                    _editedDriver.copyWith(passportExDate: newValue);
              },
              inputFormatters: [maskFormatter],
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.datetime,
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
                hintText: '',
                suffix: const Text('DD/MM/YYYY'),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                if (value.length != 10) {
                  return 'Make sure the date format is correct';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (newValue) {
                _editedDriver = _editedDriver.copyWith(
                  visaNumber: int.tryParse(newValue!),
                );
              },
              textInputAction: TextInputAction.next,
              decoration: kTextFieldDecoration.copyWith(
                labelText: 'Visa Number',
                hintText: '',
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              onSaved: (newValue) {
                _editedDriver = _editedDriver.copyWith(visaExDate: newValue);
              },
              inputFormatters: [maskFormatter],
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.datetime,
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
                hintText: '',
                suffix: const Text('DD/MM/YYYY'),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                if (value.length != 10) {
                  return 'Make sure the date format is correct';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      // if (_formKey.currentState!.validate()) {
                      //
                      if (_formKey.currentState != null) {
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) {
                          return;
                        }
                        _formKey.currentState!.save();

                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          final String jwt =
                              Provider.of<AuthService>(context, listen: false)
                                  .user
                                  .token;
                          await SteadyApiService()
                              .driversService
                              .addDriver(jwt, _editedDriver);
                        } catch (error) {
                          await showDialog<void>(
                            context: context,
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
                        Navigator.of(context).pop();
                        //
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
                    child: const Text('Submit'),
                  ),
          ),
        ],
      ),
    );
  }
}
