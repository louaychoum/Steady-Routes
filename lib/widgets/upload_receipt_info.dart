import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';

class UploadedReceiptInfo extends StatelessWidget {
  UploadedReceiptInfo(
      {@required File images, @required MoneyMaskedTextController controller})
      : _images = images,
        _controller = controller;

  final File _images;
  final MoneyMaskedTextController _controller;

  final _formKey = GlobalKey<FormState>();

  Future<File> compressFile(File file) async {
    //Todo make available for other formats
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
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
    debugPrint((file.lengthSync() / 1024).toString());
    debugPrint((result.lengthSync() / 1024).toString());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    File compressedImage;
    return Consumer<SteadyApiService>(
      builder: (context, api, child) {
        api.vehiclesService.fetchVehicles('');
        final vehicleData = api.vehiclesService.vehicles;

        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownSearch<String>(
                    searchBoxDecoration: kTextFieldDecoration.copyWith(
                      labelText: 'Vehicle Name',
                      hintText: 'Search vehicles',
                      isDense: true,
                    ),
                    showAsSuffixIcons: true,
                    dropdownSearchDecoration: kTextFieldDecoration.copyWith(
                      labelText: 'Vehicle Name',
                      hintText: 'Choose a vehicle',
                    ),
                    showClearButton: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a vehicle';
                      }
                      return null;
                    },
                    mode: Mode.BOTTOM_SHEET,
                    showSearchBox: true,
                    items: vehicleData.map((item) {
                      return item.name;
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _controller,
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Amount',
                      hintText: '',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.substring(0, value.length - 3).trim() ==
                          '0.00') {
                        return 'Please enter a valid cash amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_images == null)
                    Container()
                  else
                    ElevatedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        // if (_formKey.currentState!.validate()) {
                        if (_formKey.currentState != null) {
                          if (_formKey.currentState.validate()) {
                            debugPrint(_images.toString());
                            compressedImage = await compressFile(
                              _images,
                            );
                            if (compressedImage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: kDefaultScaffoldColor,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Uploading receipt...'),
                                ),
                              );

                              // final String jwt = Provider.of<AuthService>(
                              //         context,
                              //         listen: false)
                              //     .user.token
                              //     ;
                              final SteadyApiService api =
                                  Provider.of<SteadyApiService>(context,
                                      listen: false);
                              final bool uploadRes = await Future.delayed(
                                const Duration(
                                  seconds: 3,
                                ),
                              ).then(
                                (value) => true,
                              );
                              // await api.receiptsService
                              //     .upload('jwt', File(compressedImage.path));

                              if (uploadRes) {
                                NavigationService.popUntilRoot();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: kErrorScaffoldColor,
                                    content: Text('Upload failed.'),
                                  ),
                                );
                              }
                            }

                            //                 If the form is valid, display a snackbar. In the real world,
                            //                 you'd often call a server or save the information in a database.
                            //                 /**
                            //  ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text('Processing Data'),
                            //   ),
                            // );

                          }
                        }
                      },
                      child: const Text('Upload'),
                    ),
                  Container(
                    child: compressedImage == null
                        ? null
                        : Image.file(compressedImage),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
