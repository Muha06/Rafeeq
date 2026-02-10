enum ReminderType { quran, hadith, narration }

class RamadanReflection {
  final String id;

  /// 1..30
  final int day;

  /// e.g. "Night of Power", "Sincerity", "Dua"
  final String topic;

  /// The actual reflection text (English for now)
  final String mainText;

  /// e.g. "Qur’an 2:183" or "Bukhari 1903"
  final String sourceLabel;

  /// Optional: a short benefit/explanation
  final String? lesson;

  final ReminderType type;

  /// Optional for future filtering/searching
  final List<String> tags;

  const RamadanReflection({
    required this.id,
    required this.day,
    required this.topic,
    required this.mainText,
    required this.sourceLabel,
    this.lesson,
    required this.type,
    this.tags = const [],
  });
}
