import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/widgets/report_info.dart';

class ReceiptReport extends StatefulWidget {
  static const routeName = '/add-report';

  @override
  _ReceiptReportState createState() => _ReceiptReportState();
}

class _ReceiptReportState extends State<ReceiptReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Generate Report',
              style: kTextTitleStyle,
            ),
            const Divider(),
            Expanded(
              child: ReportInfo(),
            ),
          ],
        ),
      ),
    );
  }
}
