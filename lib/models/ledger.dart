import 'package:intl/intl.dart';
import 'package:steadyroutes/helpers/constants.dart';

class Ledger {
  final String? id;
  final String driverId;
  final String vehicleId;
  final DateTime? date;
  final String action;
  final double amount;
  final String? receipt;

  Ledger({
    this.id,
    required this.driverId,
    required this.vehicleId,
    this.date,
    required this.action,
    required this.amount,
    this.receipt,
  });

  Ledger.fromJson(Map<String, dynamic> json)
      : id = json['_id'].toString(),
        driverId = json['driver'].toString(),
        vehicleId = json['vehicle'].toString(),
        date = dateFormat
            .parse(
              json['date'].toString(),
            )
            .toLocal(),
        action = json['action'].toString(),
        amount = json['amount'] == null
            ? 0
            : double.tryParse(
                  json['amount'].toString(),
                ) ??
                0,
        receipt = json['receipt'].toString();

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        'vehicleId': vehicleId,
        'action': action,
        'amount': amount,
      };

  Ledger copyWith({
    String? id,
    String? driverId,
    String? vehicleId,
    DateTime? date,
    String? action,
    double? amount,
    String? receipt,
  }) {
    return Ledger(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      action: action ?? this.action,
      amount: amount ?? this.amount,
      receipt: receipt ?? this.receipt,
    );
  }
}
