class Progress {
  final int totalRead;
  final int dailyTarget;
  final double percentage;

  Progress({required this.totalRead, required this.dailyTarget})
    : percentage = (totalRead / dailyTarget).clamp(0, 1);
}
