class Progress {
  final int totalRead;
  final int totalTarget;
  final double percentage;

  Progress({required this.totalRead, required this.totalTarget})
    : percentage = (totalRead / totalTarget).clamp(0, 1);
}
