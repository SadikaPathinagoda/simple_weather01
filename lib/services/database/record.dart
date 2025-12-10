class Record {
  final int? id;       // auto id from DB
  final String city;   // "London, UK"
  final String label;  // "Home"
  final String region; // "Europe"
  final String note;   // optional

  Record({
    this.id,
    required this.city,
    required this.label,
    required this.region,
    required this.note,
  });

  Record copyWith({
    int? id,
    String? city,
    String? label,
    String? region,
    String? note,
  }) {
    return Record(
      id: id ?? this.id,
      city: city ?? this.city,
      label: label ?? this.label,
      region: region ?? this.region,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'label': label,
      'region': region,
      'note': note,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'] as int?,
      city: map['city'] as String,
      label: map['label'] as String,
      region: map['region'] as String,
      note: map['note'] as String,
    );
  }
}

