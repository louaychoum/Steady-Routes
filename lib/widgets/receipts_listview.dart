import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steadyroutes/models/driver.dart';

import 'package:steadyroutes/models/receipt.dart';
import 'package:steadyroutes/screens/adminDashBoardScreen/receiptScreen/receipt_review_screen.dart';

import 'package:steadyroutes/services/steady_api_service.dart';

class ReceiptListView extends StatefulWidget {
  final Driver driver;
  const ReceiptListView(this.driver);
  @override
  _ReceiptListViewState createState() => _ReceiptListViewState();
}

class _ReceiptListViewState extends State<ReceiptListView> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  late String jwt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _refreshKey.currentState!.show());
  }

  // var _isInit = true;
  // var _isLoading = false;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Receipts>(context).fetchReceipts().then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    Driver driver = widget.driver;
    // final _receiptData = Provider.of<Receipts>(context);
    // final _receipts = _receiptData.receipts;
    return
        // _isLoading
        //     ? const Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : _receipts.isEmpty
        //         ? const Center(
        //             child: Text('No receipts added yetpackage:steadyroutes.'),
        //           )
        //         :
        Consumer<SteadyApiService>(
      builder: (context, api, child) {
        return RefreshIndicator(
          key: _refreshKey,
          onRefresh: () {
            // jwt = Provider.of<AuthService>(context, listen: false).user.jwt;
            jwt = '';
            return api.receiptsService.fetchReceipts(
              jwt,
              driver.id,
            );
          },
          child: ListView.builder(
            itemCount: api.receiptsService.receipts == null
                ? 0
                : api.receiptsService.receipts.length,
            itemBuilder: (context, index) {
              final receipt = api.receiptsService.receipts[index];
              Icon statusIcon;
              if (receipt.status == Status.approved) {
                statusIcon = const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                );
              } else if (receipt.status == Status.rejected) {
                statusIcon = const Icon(
                  Icons.cancel,
                  color: Colors.red,
                );
              } else {
                statusIcon = const Icon(
                  Icons.pending,
                  color: Colors.blue,
                );
              }
              return ListTile(
                leading: statusIcon,
                title: Text(
                  receipt.id.toString(),
                ),
                trailing: Text(receipt.date),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ReceiptReview.routeName,
                    arguments: ReceiptReviewArguments(
                      receipt,
                      driver,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
