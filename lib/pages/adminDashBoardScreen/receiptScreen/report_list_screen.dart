import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/ledger.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/report_items.dart';

class ReportList extends StatelessWidget {
  static const routeName = '/report-list';

  @override
  Widget build(BuildContext context) {
    final List<dynamic> args =
        ModalRoute.of(context)!.settings.arguments! as List<dynamic>;
    final List<Ledger>? ledgers = args[0] as List<Ledger>?;
    final selectedDriver = args[1];

    final sum = ledgers
            ?.map((e) => e.amount)
            .reduce((a, b) => a + b)
            .toStringAsFixed(2) ??
        '0.00';
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reports',
              style: kTextTitleStyle,
            ),
            const Divider(),
            Expanded(
              child: ReportItems(selectedDriver.toString()),
            ),
            const Divider(),
            Text(
              'Total:\t$sum AED',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
