import 'package:flutter/material.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';

Future<void> buildErrorDialog(Object error) {
  return showDialog<void>(
    context: NavigationService.navigatorKey.currentContext!,
    builder: (ctx) => AlertDialog(
      title: const Text('An error has occured!'),
      content: Text(
        error.toString(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: const Text('Ok'),
        )
      ],
    ),
  );
}
