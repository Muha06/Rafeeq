import 'package:hijri_date/hijri.dart';
import 'package:riverpod/legacy.dart';

/// State model
class TodayHijriDate {
  final HijriDate hijri;
  final int offsetDays;

  const TodayHijriDate({required this.hijri, required this.offsetDays});

  /// Example: "Shaaban, 17, 1447"
  String get formatted => hijri.toFormat('MMMM, dd, yyyy');

  TodayHijriDate copyWith({HijriDate? hijri, int? offsetDays}) {
    return TodayHijriDate(
      hijri: hijri ?? this.hijri,
      offsetDays: offsetDays ?? this.offsetDays,
    );
  }
}

/// Provider
final hijriDateProvider =
    StateNotifierProvider<HijriDateNotifier, TodayHijriDate>(
      (ref) => HijriDateNotifier(),
    );

/// Notifier
class HijriDateNotifier extends StateNotifier<TodayHijriDate> {
  HijriDateNotifier() : super(_buildState(offsetDays: 0));

  static TodayHijriDate _buildState({required int offsetDays}) {
    final today = HijriDate.now();

    final adjusted = offsetDays == 0
        ? today
        : today.addDays(offsetDays); // ✅ capture returned date

    return TodayHijriDate(hijri: adjusted, offsetDays: offsetDays);
  }

  void setOffset(int newOffset) {
    // clamp to -2..+2
    final clamped = newOffset.clamp(-2, 2);
    state = _buildState(offsetDays: clamped);
  }

  void increment() => setOffset(state.offsetDays + 1);
  void decrement() => setOffset(state.offsetDays - 1);

  /// Call this at midnight or when app resumes if you want it always fresh
  void refresh() {
    state = _buildState(offsetDays: state.offsetDays);
  }

  void reset() => setOffset(0);
}
