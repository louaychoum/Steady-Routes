import 'package:flutter/material.dart';

import 'package:steadyroutes/widgets/check_out_form.dart';

class CheckOutScreen extends StatelessWidget {
  static const routeName = '/check-out';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CheckOutForm(),
    );
  }
}
