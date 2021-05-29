import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';

enum Status {
  approved,
  rejected,
  pending,
}

class Receipt with ChangeNotifier {
  final int id;
  final String date;
  final String url;
  final double cashAmount;
  Status? status;

  Receipt({
    required this.id,
    required this.date,
    required this.url,
    required this.cashAmount,
    this.status = Status.pending,
  });

  Receipt.fromJson(dynamic json)
      : id = int.parse(json['id'].toString()),
        date = json['date'].toString(),
        url = json['url'].toString(),
        cashAmount = double.parse(json['cashAmount'].toString()),
        status = Status.values.firstWhereOrNull(
            (s) => s.toString() == 'Status.${json['status']}');

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['url'] = url;
    data['cashAmount'] = cashAmount;
    data['status'] = status;
    return data;
  }

  Receipt copyWith({
    int? id,
    String? date,
    String? url,
    double? cashAmount,
    Status? status,
  }) {
    return Receipt(
      id: id ?? this.id,
      date: date ?? this.date,
      url: url ?? this.url,
      cashAmount: cashAmount ?? this.cashAmount,
      status: status ?? this.status,
    );
  }

  //   void _setStatusValue(Status newValue) {
  //   status = newValue;
  //   notifyListeners();
  // }

  // Future<void> toggleFavoriteStatus(String token, String userId) async {
  //   final oldStatus = status;
  //   status = !isFavorite;
  //   notifyListeners();
  //   final url =
  //       'https://myshop-d5f4e-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
  //   try {
  //     final response = await http.put(
  //       url,
  //       body: json.encode(
  //         isFavorite,
  //       ),
  //     );
  //     if (response.statusCode >= 400) {
  //       _setStatusValue(oldStatus);
  //     }
  //   } catch (error) {
  //     _setStatusValue(oldStatus);
  //   }
  // }
}
