import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/general_notifications_provider.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';

final disabledSalahPrayersProvider =
    NotifierProvider<DisabledSalahPrayersNotifier, Set<SalahPrayer>>(
      DisabledSalahPrayersNotifier.new,
    );


const actualSalats = <SalahPrayer>{
  SalahPrayer.fajr,
  SalahPrayer.dhuhr,
  SalahPrayer.asr,
  SalahPrayer.maghrib,
  SalahPrayer.isha,
};

class DisabledSalahPrayersNotifier extends Notifier<Set<SalahPrayer>> {
  final Set<SalahPrayer> _userDisabled = <SalahPrayer>{};
  bool _didSyncOnce = false;

  @override
  Set<SalahPrayer> build() {
    // 1) On first watch: sync OS permissions once (real truth > cache)
    if (!_didSyncOnce) {
      _didSyncOnce = true;
      Future.microtask(() async {
        await ref.read(systemNotifAccessProvider.notifier).sync();
      });
    }

    // 2) React to notificationsAllowed
    final notifsAllowed = ref.watch(
      systemNotifAccessProvider.select((s) => s.notificationsAllowed),
    );

    // 3) If notifications are OFF → force all salah reminders OFF
    if (!notifsAllowed) {
      return actualSalats; // everything disabled
    }

    // 4) If notifications are ON → use user toggles
    return {..._userDisabled};
  }

  bool get _notifsAllowed =>
      ref.read(systemNotifAccessProvider).notificationsAllowed;

  Future<void> toggle(SalahPrayer prayer) async {
    if (!actualSalats.contains(prayer)) return;

    // If notifications are not allowed, request first.
    if (!_notifsAllowed) {
      final allowed = await ref
          .read(systemNotifAccessProvider.notifier)
          .requestAll();

      if (!allowed) {
        // user denied → do nothing
        return;
      }
      // permissions now OK; continue
    }

    // Now do the actual toggle once
    if (_userDisabled.contains(prayer)) {
      _userDisabled.remove(prayer);
    } else {
      _userDisabled.add(prayer);
    }

    state = {..._userDisabled};
  }

  void disable(SalahPrayer prayer) {
    if (!_notifsAllowed || !actualSalats.contains(prayer)) return;
    _userDisabled.add(prayer);
    state = {..._userDisabled};
  }

  void enable(SalahPrayer prayer) {
    if (!_notifsAllowed || !actualSalats.contains(prayer)) return;
    _userDisabled.remove(prayer);
    state = {..._userDisabled};
  }

  void clear() {
    _userDisabled.clear();
    state = const {};
  }
}
