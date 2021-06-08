import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/widgets/driver_info.dart';

class AddDriver extends StatefulWidget {
  static const routeName = '/add-driver';

  @override
  _AddDriverState createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  @override
  Widget build(BuildContext context) {
     final loadedDriver =
        ModalRoute.of(context)?.settings.arguments as Driver?;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             if (loadedDriver == null)
              const Text(
                'New Driver',
                style: kTextTitleStyle,
              )
            else
              Text(
                loadedDriver.name,
                style: kTextTitleStyle,
              ),
             Expanded(
              child: DriverInfo(
                driver: loadedDriver,
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
