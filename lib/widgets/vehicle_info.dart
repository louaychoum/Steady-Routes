import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/vehicle.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/default_textfield.dart';

class VehicleInfo extends StatefulWidget {
  const VehicleInfo({
    Vehicle? vehicle,
  }) : _vehicle = vehicle;
  final Vehicle? _vehicle;
  @override
  _VehicleInfoState createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  final _formKey = GlobalKey<FormState>();
  String? vehicleId;

  DateTime selectedDate = DateTime.now();

  Vehicle _editedVehicle = Vehicle(
    id: '',
    name: '',
    plateNumber: '',
    category: '',
    status: '',
    registrationExDate: '',
    rtaExDate: '',
    rtaNumber: 0,
  );

  var _initValues = {
    'name': '',
    'plate': '',
    'category': '',
    'status': '',
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
          ? vehicleId = widget._vehicle?.id
          : vehicleId = null;
      if (vehicleId != null) {
        _editedVehicle = widget._vehicle!;
        _initValues = {
          'name': _editedVehicle.name,
          'plate': _editedVehicle.plateNumber,
          'category': _editedVehicle.category,
          'status': _editedVehicle.status,
          'registrationExDate': '',
          'rtaExDate': '',
          'rtaNumber': _editedVehicle.rtaNumber.toString(),
        };
        _regDateController.text = _editedVehicle.registrationExDate;
        _rtaDateController.text = _editedVehicle.rtaExDate;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && !isValid) return;
    _formKey.currentState?.save();
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

    // if (_formKey.currentState != null) {
    // final isValid = _formKey.currentState?.validate();
    // if (isValid != null && !isValid) return;
    // _formKey.currentState?.save();
    // setState(() {
    //   _isLoading = true;
    // });

    // try {
    //   final User user = Provider.of<AuthService>(context, listen: false).user;
    //   await SteadyApiService().driversService.addDriver(user, _editedDriver);
    // } catch (error) {
    //   await showDialog<void>(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       title: const Text('An error has occured!'),
    //       content: Text(
    //         error.toString(),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(ctx).pop();
    //           },
    //           child: const Text('Ok'),
    //         )
    //       ],
    //     ),
    //   );
    // }
    // setState(() {
    //   _isLoading = false;
    // });
    // Navigator.of(context).pop();
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
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                DefaultTextfield(
                  initialVal: _initValues['name'],
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Company Name',
                  ),
                  savedValue: (value) =>
                      _editedVehicle = _editedVehicle.copyWith(
                    name: value,
                  ),
                ),
                DefaultTextfield(
                  initialVal: _initValues['plate'],
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Vehicle Plate Number',
                  ),
                  savedValue: (value) =>
                      _editedVehicle = _editedVehicle.copyWith(
                    plateNumber: value,
                  ),
                ),
                DefaultTextfield(
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Category',
                  ),
                  initialVal: _initValues['category'],
                  savedValue: (value) =>
                      _editedVehicle = _editedVehicle.copyWith(
                    category: value,
                  ),
                ),
                DefaultTextfield(
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Status',
                  ),
                  initialVal: _initValues['status'],
                  savedValue: (value) =>
                      _editedVehicle = _editedVehicle.copyWith(
                    status: value,
                  ),
                ),
                DefaultTextfield(
                  mask: maskFormatter,
                  keyboard: TextInputType.datetime,
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
                    suffix: const Text('DD/MM/YYYY'),
                  ),
                  savedValue: (value) =>
                      _editedVehicle = _editedVehicle.copyWith(
                    registrationExDate: value,
                  ),
                ),
                DefaultTextfield(
                    keyboard: TextInputType.number,
                    initialVal: _initValues['rtaNumber'],
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'RTA License Number',
                    ),
                    savedValue: (value) {
                      if (value != null) {
                        _editedVehicle = _editedVehicle.copyWith(
                          rtaNumber: int.tryParse(value),
                        );
                      }
                    }),
                DefaultTextfield(
                  mask: maskFormatter,
                  keyboard: TextInputType.datetime,
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
                    suffix: const Text('DD/MM/YYYY'),
                  ),
                  savedValue: (value) =>
                      _editedVehicle = _editedVehicle.copyWith(
                    rtaExDate: value,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: DashboardButton(
                    'Submit',
                    _saveForm,
                  ),
                ),
              ],
            ),
          );
  }
}
