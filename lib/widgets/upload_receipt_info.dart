import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/ledger.dart';
import 'package:steadyroutes/models/vehicle.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/default_textfield.dart';
import 'package:steadyroutes/widgets/dropdown_search.dart';

class UploadedReceiptInfo extends StatelessWidget {
  //todo the image var stays after reload but vehicle doesn't
  UploadedReceiptInfo({
    required File? image,
    required TextEditingController controller,
  })  : _image = image,
        _controller = controller;

  final File? _image;
  final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  static final _log = Logger('Upload Receipt Info');

  Future<File?> compressFile(File file) async {
    //Todo make available for other formats
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(
      RegExp(r'.jp'),
    );
    final splitted = filePath.substring(0, lastIndex);
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: kCompressedImageQuality, //ca
    );
    return result;
  }

  // static int progressInt(double progress) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(
  //                                 backgroundColor: Color(
  //                                   0xFFB2DFBF, //0xFFB2DFBF
  //                                 ),
  //                                 behavior: SnackBarBehavior.floating,
  //                                 content: Text('Uploading receipt...'),
  //                               ),
  //                             );
  //   return progress.toInt();
  // }

  @override
  Widget build(BuildContext context) {
    File? compressedImage;
    String? selectedVehicle;
    String? selectedAmount;
    Ledger _editedLedger = Ledger(
      driverId: '',
      vehicleId: '',
      action: 'payment',
      amount: 0,
      receipt: '',
    );

    final auth = Provider.of<AuthService>(context, listen: false);
    final String jwt = auth.user.token;
    final String courierId = auth.courier?.id ?? '';
    final String driverId = auth.driver?.id ?? '';
    _editedLedger = _editedLedger.copyWith(
      driverId: driverId,
    );

    return Consumer<SteadyApiService>(
      builder: (context, api, child) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: DropdownSearch(
                      showAsSuffixIcons: true,
                      dropdownSearchDecoration: kTextFieldDecoration.copyWith(
                        labelText: 'Vehicle',
                        hintText: 'Choose a vehicle',
                      ),
                      searchBoxDecoration: kTextFieldDecoration.copyWith(
                        labelText: 'Vehicle',
                        hintText: 'Search vehicle',
                      ),
                      showClearButton: true,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a vehicle';
                        }
                        return null;
                      },
                      showSearchBox: true,
                      onChanged: (List<String?>? vehicle) {
                        _editedLedger = _editedLedger.copyWith(
                          vehicleId: vehicle?[1].toString(),
                        );
                      },
                      onFind: (_) async {
                        await api.vehiclesService.fetchVehicles(
                          jwt,
                          courierId,
                        );
                        return api.vehiclesService.vehicles
                            .map(
                              (e) => [
                                e.name,
                                e.id,
                              ],
                            )
                            .toList();
                      },
                    ),
                  ),
                  // DropDownSearch(
                  //   name: 'Vehicle',
                  //   savedValue: (value) =>
                  //       selectedVehicle = value!.name.toString(),
                  //   onFind: (_) async {
                  //     await api.vehiclesService.fetchVehicles(
                  //       jwt,
                  //       courierId,
                  //     );
                  //     return vehicles = api.vehiclesService.vehicles;
                  //   },
                  // ),
                  DefaultTextfield(
                    keyboard: TextInputType.number,
                    controller: _controller,
                    decoration: kTextFieldDecoration.copyWith(
                      prefixText: 'AED ',
                      labelText: 'Amount',
                    ),
                    savedValue: (value) =>
                        _editedLedger = _editedLedger.copyWith(
                      amount: double.tryParse(
                        value ?? '0',
                      ),
                    ),
                  ),
                  if (_image == null)
                    const SizedBox()
                  else
                    DashboardButton(
                      'Upload',
                      () async {
                        _log.info('Upload button pressed');
                        if (_formKey.currentState != null) {
                          final isValid = _formKey.currentState?.validate();
                          if (isValid != null && !isValid) return;
                          _formKey.currentState?.save();
                          if (_image != null) {
                            compressedImage = await compressFile(
                              _image!,
                            );
                          }
                          try {
                            if (compressedImage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(
                                    0xFFB2DFBF, //0xFFB2DFBF
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Uploading receipt...'),
                                ),
                              );

                              final bool addedReceipt =
                                  await api.ledgerService.uploadLedger(
                                jwt,
                                compressedImage ?? File(''),
                                _editedLedger,
                              );
                              if (addedReceipt) {
                                _log.info('image uploaded successfully');
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: kDefaultScaffoldColor,
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Receipt uploaded successfully!',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                                //todo
                                // if (NavigationService
                                //         .navigatorKey.currentContext !=
                                //     context) {
                                //   NavigationService.goBack();
                                // }
                              }
                              if (!addedReceipt) {
                                throw 'Try Logging out and Sign In again';
                              }
                            }
                          } catch (error) {
                            _log.warning(error);
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
                        }
                      },
                    ),
                  if (compressedImage != null)
                    SizedBox(
                      child: Image.file(compressedImage!),
                    )
                  else
                    const SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
