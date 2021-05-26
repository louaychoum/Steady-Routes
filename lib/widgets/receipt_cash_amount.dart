import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:steadyroutes/helpers/constants.dart';
import 'package:steadyroutes/models/receipt.dart';

class ReceiptCashAmount extends StatefulWidget {
  final Receipt _receipt;
  const ReceiptCashAmount(this._receipt);
  @override
  _ReceiptCashAmountState createState() => _ReceiptCashAmountState();
}

class _ReceiptCashAmountState extends State<ReceiptCashAmount> {
  final _controller = MoneyMaskedTextController(
    rightSymbol: ' AED',
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  var _isInit = true;
  int receiptId;

  var _editedReceipts = Receipt(
    cashAmount: null,
    date: '',
    id: null,
    status: null,
    url: '',
  );

  // var _initValues = {
  //   'cashAmount': '',
  //   'date': '',
  //   'id': '',
  //   'status': '',
  //   'url': '',
  // };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      widget._receipt != null
          ? receiptId = widget._receipt.id
          : receiptId = null;
      if (receiptId != null) {
        _editedReceipts = widget._receipt;
        // _initValues = {
        //   'date': _editedReceipts.date,
        //   'id': _editedReceipts.id.toString(),
        //   'status': _editedReceipts.status.toString(),
        //   'url': _editedReceipts.url,
        // };
        print(_editedReceipts.cashAmount);
        _controller.text = _editedReceipts.cashAmount.toStringAsFixed(2);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _controller,
      decoration: kTextFieldDecoration.copyWith(
        labelText: 'Amount',
        hintText: '',
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value.substring(0, value.length - 3).trim() == '0.00') {
          return 'Please enter a valid cash amount';
        }
        return null;
      },
    );
  }
}
