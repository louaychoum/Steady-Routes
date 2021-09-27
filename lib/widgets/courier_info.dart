import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/courier.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/default_textfield.dart';
import 'package:steadyroutes/widgets/dropdown_search.dart';

class CourierInfo extends StatefulWidget {
  @override
  _CourierInfoState createState() => _CourierInfoState();
}

class _CourierInfoState extends State<CourierInfo> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Courier _editedCourier = Courier(
    id: '',
    name: '',
    location: null,
    // zoneId: '',
    phone: 0,
    user: null,
  );

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final String jwt = auth.user.token;
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
                        savedValue: (newValue) {
                          _editedCourier =
                              _editedCourier.copyWith(name: newValue);
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Courier Name',
                        ),
                      ),
                      DefaultTextfield(
                        savedValue: (newValue) {
                          _editedCourier =
                              _editedCourier.copyWith(user: newValue);
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Email',
                        ),
                        keyboard: TextInputType.emailAddress,
                      ),
                      DefaultTextfield(
                        savedValue: (newValue) {
                          _editedCourier =
                              _editedCourier.copyWith(user: newValue);
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Password',
                        ),
                        isPassword: true,
                      ),
                      DefaultTextfield(
                        keyboard: TextInputType.number,
                        savedValue: (newValue) {
                          _editedCourier = _editedCourier.copyWith(
                            phone: int.tryParse(newValue ?? ''),
                          );
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Phone Number',
                        ),
                      ),
                      DefaultTextfield(
                        savedValue: (newValue) {
                          _editedCourier =
                              _editedCourier.copyWith(location: newValue);
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Location',
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
                            if (_formKey.currentState != null) {
                              final isValid = _formKey.currentState?.validate();
                              if (isValid != null && !isValid) return;
                              _formKey.currentState?.save();
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                final bool addedCourier = await api
                                    .courierService
                                    .addCourier(jwt, _editedCourier);
                                if (!addedCourier) {
                                  throw 'Try Logging out and Signing In again';
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
