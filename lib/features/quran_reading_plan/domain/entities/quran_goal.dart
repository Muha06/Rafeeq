import 'package:intl/intl.dart';

class QuranReadingPlan {
  final int dailyTarget; // e.g., 50 ayahs
  final DateTime createdAt; // goal start date
  final bool isActive; // is this goal currently active?

  QuranReadingPlan({
    required this.dailyTarget,
    required this.createdAt,
    this.isActive = true, // default to active
  });

  // Optional: helper to get formatted start date
  String get formattedStartDate =>
      DateFormat('EEEE, d MMMM yyyy').format(createdAt);

  QuranReadingPlan copyWith({
    int? dailyTarget,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return QuranReadingPlan(
      dailyTarget: dailyTarget ?? this.dailyTarget,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
