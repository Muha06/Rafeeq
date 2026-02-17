class QuranGoal {
  final int dailyTarget; // e.g., 50 ayahs
  final DateTime createdAt; // goal start date
  final bool isActive; // is this goal currently active?

  QuranGoal({
    required this.dailyTarget,
    required this.createdAt,
    this.isActive = true, // default to active
  });

  // Optional: helper to get formatted start date
  String get formattedStartDate =>
      "${createdAt.day}/${createdAt.month}/${createdAt.year}";

  QuranGoal copyWith({int? dailyTarget, DateTime? createdAt, bool? isActive}) {
    return QuranGoal(
      dailyTarget: dailyTarget ?? this.dailyTarget,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
