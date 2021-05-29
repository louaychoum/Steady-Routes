import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/vehicle.dart';

class VehicleInfo extends StatefulWidget {
  const VehicleInfo({
    Vehicle vehicle,
  }) : _vehicle = vehicle;
  final Vehicle _vehicle;
  @override
  _VehicleInfoState createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  final _formKey = GlobalKey<FormState>();
  int vehicleId;

  DateTime selectedDate = DateTime.now();

  var _editedVehicles = Vehicle(
    id: null,
    name: '',
    plateNumber: '',
    registrationExDate: '',
    rtaExDate: '',
    rtaNumber: null,
  );

  var _initValues = {
    'name': '',
    'plateNumber': '',
    'registrationExDate': '',
    'rtaExDate': '',
    'rtaNumber': '',
  };

  var _isInit = true;

  var _isLoading = false;

  final _regDateController = TextEditingController();
  final _rtaDateController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  @override
  void didChangeDependencies() {
    if (_isInit) {
      widget._vehicle != null
          ? vehicleId = widget._vehicle.id
          : vehicleId = null;
      if (vehicleId != null) {
        _editedVehicles = widget._vehicle;
        _initValues = {
          'name': _editedVehicles.name,
          'plateNumber': _editedVehicles.plateNumber,
          'registrationExDate': '',
          'rtaExDate': '',
          'rtaNumber': _editedVehicles.rtaNumber.toString(),
        };
        _regDateController.text = _editedVehicles.registrationExDate;
        _rtaDateController.text = _editedVehicles.rtaExDate;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    // if (_editedVehicles.id != null) {
    //   await Provider.of<Vehicles>(context, listen: false)
    //       .updateProduct(_editedVehicles.id, _editedVehicles);
    // } else {
    //   try {
    //     await Provider.of<Vehicles>(context, listen: false)
    //         .addProduct(_editedVehicles);
    //   } catch (error) {
    //     await showDialog(
    //       context: context,
    //       builder: (ctx) => AlertDialog(
    //         title: const Text('An error has occured!'),
    //         content: const Text('Something went wrong.'),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(ctx).pop();
    //             },
    //             child: const Text('Ok'),
    //           )
    //         ],
    //       ),
    //     );
    //   }
    //   // finally {
    //   //   setState(() {
    //   //     _isLoading = false;
    //   //   });
    //   //   Navigator.of(context).pop();
    //   // }
    // }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _regDateController.dispose();
    _rtaDateController.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
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
          selectedDate = DateTime.now();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final receiptId = ModalRoute.of(context).settings.arguments as int;
    // final loadedVehicles = Provider.of<Vehicles>(
    //   context,
    //   listen: false,
    // ).findById(receiptId);
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: TextFormField(
                    initialValue: _initValues['name'],
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Company Name',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: TextFormField(
                    initialValue: _initValues['plateNumber'],
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: TextFormField(
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.datetime,
                    controller: _regDateController,
                    decoration: kTextFieldDecoration.copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_sharp,
                        ),
                        onPressed: () => _selectDate(
                          context,
                          _regDateController,
                        ),
                      ),
                      labelText: 'Registration Expiry Date',
                      hintText: '',
                      suffix: const Text('DD/MM/YYYY'),
                    ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: TextFormField(
                    initialValue: _initValues['rtaNumber'],
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'RTA License Number',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: TextFormField(
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.datetime,
                    controller: _rtaDateController,
                    decoration: kTextFieldDecoration.copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_sharp,
                        ),
                        onPressed: () => _selectDate(
                          context,
                          _rtaDateController,
                        ),
                      ),
                      labelText: 'RTA License Expiry Date',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          );
  }
}
