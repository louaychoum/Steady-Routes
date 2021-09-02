import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/vehicle.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/default_textfield.dart';
import 'package:steadyroutes/widgets/dropdown_search.dart';

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
    rtaNumber: '',
    courierId: '',
  );

  var _initValues = {
    'name': '',
    'plate': '',
    'category': '',
    'courierId': '',
    'status': '',
    'registrationExpiryDate': '',
    'licenseExpiryDate': '',
    'licenseNo': '',
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
          'rtaNumber': _editedVehicle.rtaNumber.toString(),
        };
        _regDateController.text = _editedVehicle.registrationExDate;
        _rtaDateController.text = _editedVehicle.rtaExDate;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      DropDownSearch(
                        name: 'Category',
                        savedValue: (value) =>
                            _editedVehicle = _editedVehicle.copyWith(
                          category: value,
                        ),
                        items: kVehicleCategoryDropDownItems,
                        initialValue: _initValues['category'],
                      ),
                      DropDownSearch(
                        name: 'Status',
                        savedValue: (value) =>
                            _editedVehicle = _editedVehicle.copyWith(
                          status: value,
                        ),
                        items: kVehicleStatusDropDownItems,
                        initialValue: _initValues['status'],
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
                                rtaNumber: value,
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
                      DashboardButton(
                        'Submit',
                        () async {
                          if (_formKey.currentState != null) {
                            final isValid = _formKey.currentState?.validate();
                            if (isValid != null && !isValid) return;
                            _formKey.currentState?.save();
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              await api.vehiclesService
                                  .addVehicle(jwt, courierId, _editedVehicle);
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
