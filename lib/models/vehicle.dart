class Vehicle {
  final String? id;
  final String name;
  final String plateNumber;
  final String category;
  final String status;
  final String registrationExDate;
  final int rtaNumber;
  final String rtaExDate;

  Vehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.category,
    required this.status,
    required this.registrationExDate,
    required this.rtaNumber,
    required this.rtaExDate,
  });

  Vehicle.fromJson(dynamic json)
      : id = json['_id'].toString(),
        name = json['name'].toString(),
        plateNumber = json['plate'].toString(),
        category = json['category'].toString(),
        status = json['status'].toString(),
        registrationExDate = json['registrationExDate'].toString(),
        rtaNumber = int.tryParse(json['rtaNumber'].toString()) ?? 0,
        rtaExDate = json['rtaExDate'].toString();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['status'] = status;
    data['plateNumber'] = plateNumber;
    data['registrationExDate'] = registrationExDate;
    data['rtaNumber'] = rtaNumber;
    data['rtaExDate'] = rtaExDate;
    return data;
  }

  Vehicle copyWith({
    String? id,
    String? name,
    String? plateNumber,
    String? category,
    String? status,
    String? registrationExDate,
    int? rtaNumber,
    String? rtaExDate,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      category: category ?? this.category,
      status: status ?? this.status,
      registrationExDate: registrationExDate ?? this.registrationExDate,
      rtaNumber: rtaNumber ?? this.rtaNumber,
      rtaExDate: rtaExDate ?? this.rtaExDate,
    );
  }
}
