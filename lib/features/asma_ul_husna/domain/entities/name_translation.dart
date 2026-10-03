class AllahNameTranslation {
  final String name; // 
  final String meaning;
  final String details;

  const AllahNameTranslation({
    required this.name,
    required this.meaning,
    required this.details,
  });

  factory AllahNameTranslation.fromJson(Map<String, dynamic> json) {
    return AllahNameTranslation(
      name: json['name'] as String,
      meaning: json['meaning'] as String,
      details: json['details'] as String,
    );
  }
}
