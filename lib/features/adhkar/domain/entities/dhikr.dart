class Dhikr {
  final String id;
  final String title;
  final String arabic;
  final String? latin;
  final String? translation;
  final String? notes;
  final String? benefits;
  final String? source;
  final String? fawaid;

  const Dhikr({
    required this.id,
    required this.title,
    required this.arabic,
    this.latin,
    this.translation,
    this.notes,
    this.benefits,
    this.source,
    this.fawaid,
  });

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    String? s(dynamic v) => v?.toString();

    return Dhikr(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      arabic: (json['arabic'] ?? '').toString(),
      latin: s(json['latin']),
      translation: s(json['translation']),
      notes: s(json['notes']),
      benefits: s(json['benefits']),
      source: s(json['source']),
      fawaid: s(json['fawaid']),
    );
  }
}
