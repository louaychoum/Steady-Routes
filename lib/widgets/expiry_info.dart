import 'package:flutter/material.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/pages/adminDashBoardScreen/receiptScreen/expiry_list_screen.dart';

class ExpiryInfo extends StatefulWidget {
  @override
  _ExpiryInfoState createState() => _ExpiryInfoState();
}

class _ExpiryInfoState extends State<ExpiryInfo> {
  final _formKey = GlobalKey<FormState>();
  String? /*late*/ _typeController;
  int? /*late*/ _monthController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: DropdownButtonFormField(
              icon: const Icon(
                Icons.receipt_outlined,
              ),
              validator: (dynamic value) {
                if (value == null) {
                  return 'Please enter a valid Report Type';
                }
                return null;
              },
              value: _typeController,
              items: kExReportDropDownItems
                  .map(
                    (label) => DropdownMenuItem(
                      value: label,
                      child: Text(
                        label.toString(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (dynamic value) {
                setState(() {
                  _typeController = value.toString();
                });
              },
              decoration:
                  kTextFieldDecoration.copyWith(labelText: 'Report Type'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: DropdownButtonFormField(
              icon: const Icon(
                Icons.calendar_today,
              ),
              validator: (dynamic value) {
                if (value == null) {
                  return 'Please enter number of months left till expiry';
                }
                return null;
              },
              value: _monthController,
              items: kMonthCountDropDownItems
                  .map(
                    (label) => DropdownMenuItem(
                      value: label,
                      child: Text(
                        label.toString(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (dynamic value) {
                setState(() {
                  _monthController = value as int?;
                });
              },
              decoration:
                  kTextFieldDecoration.copyWith(labelText: 'Months Remaining'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                // if (_formKey.currentState!.validate()) {
                if (_formKey.currentState != null) {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    /** 
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Processing Data'),
                      ),
                    );
                    */

                    Navigator.of(context).pushNamed(ExpiryList.routeName,
                        arguments: _typeController);
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
