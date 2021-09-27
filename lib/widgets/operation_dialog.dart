import 'package:flutter/material.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';

Future<void> showMyDialog({
  required BuildContext context,
  required String message,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('\u{2705} Operation Successful'),
        content: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            message,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              NavigationService.popUntilRoot();
            },
            child: const Text('Approve'),
          ),
        ],
      );
    },
  );
}
