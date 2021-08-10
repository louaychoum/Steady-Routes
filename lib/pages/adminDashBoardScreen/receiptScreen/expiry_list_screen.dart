import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/expiry_drivers.dart';
import 'package:steadyroutes/widgets/drivers_listview.dart';

class ExpiryList extends StatelessWidget {
  static const routeName = '/expiry-list';

  @override
  Widget build(BuildContext context) {
    final reportType = ModalRoute.of(context)?.settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reportType ?? '',
              style: kTextTitleStyle,
            ),
            const Divider(),
            Expanded(
              child: ExpiryDrivers(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 5.0),
                      )),
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text('SAVE \u{1F4BE}'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
