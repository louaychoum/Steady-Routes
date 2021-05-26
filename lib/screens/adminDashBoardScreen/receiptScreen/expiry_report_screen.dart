import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/widgets/expiry_info.dart';

class ExpiryReport extends StatefulWidget {
  static const routeName = '/expiry-report';

  @override
  _ExpiryReportState createState() => _ExpiryReportState();
}

class _ExpiryReportState extends State<ExpiryReport> {
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
              'Near Expiry Report',
              style: kTextTitleStyle,
            ),
            const Divider(
              color: Colors.red,
            ),
            Expanded(
              flex: 8,
              child: ExpiryInfo(),
            ),
          ],
        ),
      ),
    );
  }
}
