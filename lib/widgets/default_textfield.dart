import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DefaultTextfield extends StatelessWidget {
  const DefaultTextfield({
    required this.decoration,
    this.isPassword = false,
    required this.savedValue,
    this.keyboard = TextInputType.text,
  });
  final InputDecoration decoration;
  final bool isPassword;
  final ValueChanged<String?> savedValue;
  final TextInputType keyboard;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: decoration,
      obscureText: isPassword,
      keyboardType: keyboard,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "${decoration.labelText} can't be empty!";
        }
        if (value.trim().length < 7) {
          return '"${decoration.labelText} is too short!';
        }
        return null;
      },
      onSaved: (value) => savedValue(
        value?.trim() ?? '',
      ),
    );
  }
}
