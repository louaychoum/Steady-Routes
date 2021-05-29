import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/screens/driverDashboardScreen/driver_dashboard_screen.dart';
import 'package:steadyroutes/services/navigator_sevice.dart';
import 'package:steadyroutes/widgets/mall_dropdown.dart';

class CheckOutForm extends StatefulWidget {
  @override
  _CheckOutFormState createState() => _CheckOutFormState();
}

class _CheckOutFormState extends State<CheckOutForm> {
  late DateTime now;
  late String selectedValue;
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _showMyDialog(String value, String time) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('\u{2705} Operation Successful'),
          content: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Checked Out At Mall: $value \nWith Cash amount of: ${_controller.text == '0.00 AED' ? 'Not Available' : _controller.text}\nAt time: $time',
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(
              flex: 4,
            ),
            MallDropdown(
              (newVal) {
                selectedValue = newVal!;
              },
            ),
            const Spacer(),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _controller,
              decoration: kTextFieldDecoration.copyWith(
                prefixText: 'AED ',
                labelText: 'Amount',
                hintText: '',
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null) {
                  return 'Please enter a valid cash amount';
                }
                return null;
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState != null) {
                  if (_formKey.currentState!.validate()) {
                    now = DateTime.now();
                    final String convertedDateTime =
                        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}-${now.minute.toString()}";
                    _showMyDialog(selectedValue, convertedDateTime);
                  }
                }
              },
              child: const Text(
                'Check Out',
              ),
            ),
            const Spacer(
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
