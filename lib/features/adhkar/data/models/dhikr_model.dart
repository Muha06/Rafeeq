import '../../domain/entities/dhikr.dart';

class DhikrModel {
  final String id;
  final String title;
  final String arabic;
  final String? latin;
  final String? translation;
  final String? notes;
  final String? benefits;
  final String? source;
  final String? fawaid;

  const DhikrModel({
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

  //from JSON
  factory DhikrModel.fromJson(Map<String, dynamic> json) {
    //Trim & return the string
    String? s(dynamic v) {
      final str = v?.toString();
      if (str == null) return null;
      final trimmed = str.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    // Some files use "fawaid" instead of "benefits" (or vice versa)
    final benefits = s(json['benefits']) ?? s(json['fawaid']);
    final fawaid = s(json['fawaid']) ?? s(json['benefits']);

    return DhikrModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      arabic: (json['arabic'] ?? '').toString(),
      latin: s(json['latin']),
      translation: s(json['translation']),
      notes: s(json['notes']),
      benefits: benefits,
      source: s(json['source']),
      fawaid: fawaid,
    );
  }

  //to json
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'arabic': arabic,
    'latin': latin,
    'translation': translation,
    'notes': notes,
    'benefits': benefits,
    'source': source,
    'fawaid': fawaid,
  };

  //to entity
  Dhikr toEntity() => Dhikr(
    id: id,
    title: title,
    arabic: arabic,
    latin: latin,
    translation: translation,
    notes: notes,
    benefits: benefits,
    source: source,
    fawaid: fawaid,
  );
}
