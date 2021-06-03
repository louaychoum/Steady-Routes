import 'package:flutter/material.dart';

import 'package:steadyroutes/widgets/check_in_form.dart';

class CheckInScreen extends StatelessWidget {
  static const routeName = '/check-in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CheckInForm(),
      ),
    );
  }
}
