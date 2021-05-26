import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  const DashboardButton(
    this.text,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(text),
    );
  }
}
