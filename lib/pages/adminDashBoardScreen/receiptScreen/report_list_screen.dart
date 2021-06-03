import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';

class ReportList extends StatelessWidget {
  static const routeName = '/report-list';

  final myProducts =
      List<String>.generate(10, (i) => '2021-12-${i + 1}     123 AED ');

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
              'Report',
              style: kTextTitleStyle,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: myProducts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(myProducts[index]),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  '2222 AED',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
