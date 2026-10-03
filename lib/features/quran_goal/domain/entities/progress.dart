class Progress {
  final int totalRead;
  final int totalTarget;
  final double percentage;

  Progress({required this.totalRead, required this.totalTarget})
    : percentage = totalTarget == 0
          ? 0
          : (totalRead / totalTarget).clamp(0.0, 1.0);
}
