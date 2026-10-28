// domain/repositories/radio_favorites_repository.dart
abstract class RadioFavoritesRepository {
  List<String> getFavoriteIds();
  Future<void> add(String stationId);
  Future<void> remove(String stationId);
}
