class ArriveCheck {
  final String ognoo; // Өдрийн мэдээлэл
  final int itgegchId; // Итгэгчийн ID

  ArriveCheck(
      {required this.ognoo, required this.itgegchId, required String value});

  // JSON-оос объект үүсгэх
  factory ArriveCheck.fromJson(Map<String, dynamic> json) {
    return ArriveCheck(
      ognoo: json['ognoo'],
      itgegchId: json['itgegch_id'],
      value: json['value'],
    );
  }

  // Объектээс JSON үүсгэх
  Map<String, dynamic> toJson() {
    return {
      'ognoo': ognoo,
      'itgegch_id': itgegchId,
    };
  }
}
