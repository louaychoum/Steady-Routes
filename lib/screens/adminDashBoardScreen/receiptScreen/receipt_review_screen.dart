import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/driver.dart';
import 'package:steadyroutes/models/receipt.dart';
import 'package:steadyroutes/services/steady_api_service.dart';
import 'package:steadyroutes/widgets/receipt_cash_amount.dart';

class ReceiptReviewArguments {
  final Receipt receipt;
  final Driver driver;
  ReceiptReviewArguments(
    this.receipt,
    this.driver,
  );
}

class ReceiptReview extends StatelessWidget {
  static const routeName = '/receipt-review';
  static ReceiptReviewArguments args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as ReceiptReviewArguments;
    // final receiptId = ModalRoute.of(context).settings.arguments as int;
    // final loadedReceipt = Provider.of<Receipts>(
    //   context,
    //   listen: false,
    // ).findById(receiptId);
    final loadedReceipt = args.receipt;
    final loadedDriver = args.driver;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${loadedReceipt.date}\t${loadedDriver.name}',
          style: kTextTitleStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Image.network(loadedReceipt.url),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: ReceiptCashAmount(loadedReceipt),
            ),
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<SteadyApiService>(
                          context,
                          listen: false,
                        ).receiptsService.updateReceiptStatus(
                            loadedReceipt.id, Status.rejected);
                        Navigator.of(context).pop();
                      },
                      child: const FittedBox(
                        child: Text(
                          'Reject',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 4,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
                      ),
                      onPressed: () {
                        Provider.of<SteadyApiService>(
                          context,
                          listen: false,
                        ).receiptsService.updateReceiptStatus(
                            loadedReceipt.id, Status.approved);
                        Navigator.of(context).pop();
                      },
                      child: const FittedBox(
                        child: Text(
                          'Approve',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
