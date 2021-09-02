import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/widgets/courier_info.dart';

class AddUser extends StatelessWidget {
  static const routeName = '/add-user';

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
              'New Courier',
              style: kTextTitleStyle,
            ),
            const Divider(),
            Expanded(
              child: CourierInfo(),
            ),
          ],
        ),
      ),
    );
  }
}
