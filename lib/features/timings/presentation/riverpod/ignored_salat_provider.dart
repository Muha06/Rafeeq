import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:riverpod/legacy.dart';

final disabledSalahPrayersProvider =
    StateNotifierProvider<DisabledSalahPrayersNotifier, Set<SalahPrayer>>(
      (ref) => DisabledSalahPrayersNotifier(),
    );

class DisabledSalahPrayersNotifier extends StateNotifier<Set<SalahPrayer>> {
  DisabledSalahPrayersNotifier() : super(const {});

  void disable(SalahPrayer prayer) => state = {...state, prayer};

  void enable(SalahPrayer prayer) {
    final next = {...state};
    next.remove(prayer);
    state = next;
  }

  void toggle(SalahPrayer prayer) =>
      state.contains(prayer) ? enable(prayer) : disable(prayer);

  void setAll(Set<SalahPrayer> prayers) => state = {...prayers};

  void clear() => state = const {};
}
