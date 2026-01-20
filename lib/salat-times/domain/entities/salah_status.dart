import 'salah_prayer.dart';

class SalahStatusEntity {
  final SalahPrayer current; //current salah
  final SalahPrayer next; //next salah

  final DateTime currentStart; //current salah start time
  final DateTime nextStart;

  final Duration timeToNext;
  final double progress; // 0..1

  const SalahStatusEntity({
    required this.current,
    required this.next,
    required this.currentStart,
    required this.nextStart,
    required this.timeToNext,
    required this.progress,
  });
}
