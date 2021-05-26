import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/driver.dart';

class DriverInfo extends StatefulWidget {
  @override
  _DriverInfoState createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {
  final _formKey = GlobalKey<FormState>();

  final _licenseDateController = MaskedTextController(
    mask: '00/00/0000',
  );
  final _passportDateController = MaskedTextController(
    mask: '00/00/0000',
  );
  final _visaDateController = MaskedTextController(
    mask: '00/00/0000',
  );

  DateTime selectedDate = DateTime.now();

  Driver _editedDriver = Driver(
    id: null,
    name: '',
    company: '',
    drivingLicense: null,
    drivingLicenseExDate: '',
    passportExDate: '',
    passportNumber: null,
    plateNumber: '',
    username: '',
    visaExDate: '',
    visaNumber: null,
  );

  Future<void> _selectDate(
    BuildContext context,
    MaskedTextController controller,
  ) async {
    final DateTime picked = await showDatePicker(
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
                _editedDriver = _editedDriver.copyWith(username: newValue);
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
              onSaved: (newValue) {
                _editedDriver = _editedDriver.copyWith(
                  drivingLicense: int.parse(newValue),
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
                _editedDriver = _editedDriver.copyWith(
                  visaNumber: int.parse(newValue),
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
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                // if (_formKey.currentState!.validate()) {
                //
                if (_formKey.currentState != null) {
                  final isValid = _formKey.currentState.validate();
                  if (!isValid) {
                    return;
                  }
                  _formKey.currentState.save();
                  //
                  // setState(() {
                  //   _isLoading = true;
                  // });
                  //
                  // try {
                  //   await Provider.of<Drivers>(context, listen: false)
                  //       .addProduct(_editedProduct);
                  // } catch (error) {
                  //   await showDialog<Null>(
                  //     context: context,
                  //     builder: (ctx) => AlertDialog(
                  //       title: Text('An error has occured!'),
                  //       content: Text('Something went wrong.'),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () {
                  //             Navigator.of(ctx).pop();
                  //           },
                  //           child: Text('Ok'),
                  //         )
                  //       ],
                  //     ),
                  //   );
                  // }
                  //              setState(() {
                  //   _isLoading = false;
                  // });
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
