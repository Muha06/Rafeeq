import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_station.dart';
import 'package:rafeeq/features/quran_radio/domain/repository/radio_favorites_repo.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/radio_controller.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/wiring_providers.dart';

class RadioFavoritesNotifier extends Notifier<Set<String>> {
  RadioFavoritesRepository get _repo =>
      ref.read(radioFavoritesRepositoryProvider);

  @override
  Set<String> build() => _repo.getFavoriteIds().toSet();

  Future<void> toggle(String stationId) async {
    final wasFavorite = state.contains(stationId);

    // Optimistic update so the heart responds instantly.
    state = wasFavorite
        ? ({...state}..remove(stationId))
        : {stationId, ...state};

    try {
      if (wasFavorite) {
        await _repo.remove(stationId);
      } else {
        await _repo.add(stationId);
      }
    } catch (_) {
      // Roll back if the write failed.
      state = wasFavorite
          ? {stationId, ...state}
          : ({...state}..remove(stationId));
    }
  }
}

final radioFavoritesProvider =
    NotifierProvider<RadioFavoritesNotifier, Set<String>>(
      RadioFavoritesNotifier.new,
    );

/// Rebuilds only the widget watching one station.
final isFavoriteStationProvider = Provider.family<bool, String>(
  (ref, stationId) => ref.watch(
    radioFavoritesProvider.select((favs) => favs.contains(stationId)),
  ),
);

final favoriteStationsProvider = Provider<List<RadioStation>>((ref) {
  final favoriteIds = ref.watch(radioFavoritesProvider);
  final state = ref.watch(radioControllerProvider);

  if (state is! RadioLoaded) return const [];

  final byId = {for (final s in state.stations) s.id: s};

  return [
    for (final id in favoriteIds)
      if (byId[id] != null) byId[id]!,
  ];
});
