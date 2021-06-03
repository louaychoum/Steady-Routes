import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/widgets/driver_info.dart';

class AddDriver extends StatefulWidget {
  static const routeName = '/add-driver';

  @override
  _AddDriverState createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver Information',
              style: kTextTitleStyle,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(5),
                child: DriverInfo(),
              ),
            ),
          ],
        ),
      ),
    );
    //providers driver

    // saveForm() {
    //
    //   final isValid = _formKey.currentState.validate();
    //   if (!isValid) {
    //     return;
    //   }
    //   _formKey.currentState.save();
    //   Provider.of<Products>(ctx, llisten: false).addProduct(editedpr);
    // }
  }
}
//ToDo
//dispose controllers
