class Duureg {
  final int id;
  final String ner;
  final String createdAt;
  final String updatedAt;
  final int busId;

  Duureg({
    required this.id,
    required this.ner,
    required this.createdAt,
    required this.updatedAt,
    required this.busId,
  });

  factory Duureg.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Duureg(id: 0, ner: "", createdAt: "", updatedAt: "", busId: 0);
    }
    return Duureg(
      id: json['id'] ?? 0,
      ner: json['ner'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      busId: json['bus_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ner': ner,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'bus_id': busId,
    };
  }
}
