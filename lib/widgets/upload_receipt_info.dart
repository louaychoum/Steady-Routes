import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/services/auth_service.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/dashboard_button.dart';
import 'package:steadyroutes/widgets/default_textfield.dart';
import 'package:steadyroutes/widgets/dropdown_search.dart';

class UploadedReceiptInfo extends StatelessWidget {
  UploadedReceiptInfo({
    required File? image,
    required TextEditingController controller,
  })  : _image = image,
        _controller = controller;

  final File? _image;
  File? compressedImage;
  bool isLoading = false;
  final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  Future<File?> compressFile(File file) async {
    //Todo make available for other formats
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(
      RegExp(r'.jp'),
    );
    final splitted = filePath.substring(0, lastIndex);
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final result = await (FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: kCompressedImageQuality, //ca
    ) as Future<File?>);
    debugPrint((file.lengthSync() / 1024).toString());
    debugPrint((result?.lengthSync() ?? 1024 / 1024).toString());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final String jwt = auth.user.token;
    final String courierId = auth.courier?.id ?? '';
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Consumer<SteadyApiService>(
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
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                        DefaultTextfield(
                          keyboard: TextInputType.number,
                          controller: _controller,
                          decoration: kTextFieldDecoration.copyWith(
                            prefixText: 'AED ',
                            labelText: 'Amount',
                          ),
                          savedValue: (String? value) {},
                        ),
                        if (_image == null)
                          const SizedBox()
                        else if (isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else
                          DashboardButton('Upload', () async {
                            if (_formKey.currentState != null) {
                              final isValid = _formKey.currentState?.validate();
                              if (isValid != null && !isValid) return;
                              _formKey.currentState?.save();
                              //   setState(() {
                              //   _isLoading = true;
                              // });
                              if (_image != null) {
                                compressedImage = await compressFile(
                                  _image!,
                                );
                              }
                              try {
                                if (compressedImage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: kDefaultScaffoldColor,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text('Uploading receipt...'),
                                    ),
                                  );
                                  final bool addedReceipt = await api
                                      .receiptsService
                                      .upload(jwt, compressedImage!);
                                  if (!addedReceipt) {
                                    throw 'Try Logging out and Sign In again';
                                  }
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
                            }
                          }),
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
