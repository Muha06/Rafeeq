import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/features/calendar/datasources/calender_local_ds.dart';
import 'package:riverpod/legacy.dart';

/// Storage provider
final hijriOffsetStorageProvider = Provider<HijriOffsetStorage>((ref) {
  return HijriOffsetStorage();
});

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
    StateNotifierProvider<HijriDateNotifier, TodayHijriDate>((ref) {
      final storage = ref.read(hijriOffsetStorageProvider);
      final savedOffset = storage.readOffset(); // ✅ load from Hive immediately
      return HijriDateNotifier(storage: storage, initialOffset: savedOffset);
    });

/// Notifier
class HijriDateNotifier extends StateNotifier<TodayHijriDate> {
  HijriDateNotifier({
    required HijriOffsetStorage storage,
    required int initialOffset,
  }) : _storage = storage,
       super(_buildState(offsetDays: initialOffset));

  final HijriOffsetStorage _storage;

  static TodayHijriDate _buildState({required int offsetDays}) {
    final today = HijriDate.now();
    final adjusted = offsetDays == 0
        ? today
        : today.addDays(offsetDays); 
    return TodayHijriDate(hijri: adjusted, offsetDays: offsetDays);
  }

  Future<void> setOffset(int newOffset) async {
    final clamped = newOffset.clamp(-2, 2);

    // update state (UI reacts instantly)
    state = _buildState(offsetDays: clamped);

    // persist
    await _storage.writeOffset(clamped);
  }

  Future<void> increment() => setOffset(state.offsetDays + 1);
  Future<void> decrement() => setOffset(state.offsetDays - 1);
  Future<void> reset() => setOffset(0);

  void refresh() {
    // no persistence needed here
    state = _buildState(offsetDays: state.offsetDays);
  }
}
