import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DefaultTextfield extends StatelessWidget {
  const DefaultTextfield({
    Key? key,
    required this.decoration,
    this.isPassword = false,
    this.initialVal = '',
    required this.savedValue,
    this.keyboard = TextInputType.text,
    this.controller,
    this.mask,
  }) : super(key: key);
  final InputDecoration decoration;
  final bool isPassword;
  final dynamic initialVal;
  final ValueChanged<String?> savedValue;
  final TextInputType keyboard;
  final TextEditingController? controller;
  final MaskTextInputFormatter? mask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: controller == null
          ? TextFormField(
              inputFormatters: [
                mask ?? MaskTextInputFormatter(),
              ],
              initialValue: initialVal.toString(),
              textInputAction: TextInputAction.next,
              decoration: decoration,
              obscureText: isPassword,
              keyboardType: keyboard,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "${decoration.labelText} can't be empty!";
                }
                if (value.trim().length < 3) {
                  return '"${decoration.labelText} is too short!';
                }
                return null;
              },
              onSaved: (value) => savedValue(
                value?.trim() ?? '',
              ),
            )
          : TextFormField(
              inputFormatters: [
                mask ?? MaskTextInputFormatter(),
              ],
              controller: controller,
              textInputAction: TextInputAction.next,
              decoration: decoration,
              obscureText: isPassword,
              keyboardType: keyboard,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "${decoration.labelText} can't be empty!";
                }
                if (value.trim().length < 3) {
                  return '"${decoration.labelText} is too short!';
                }
                return null;
              },
              onSaved: (value) => savedValue(
                value?.trim() ?? '',
              ),
            ),
    );
  }
}
