// data/datasources/radio_favorites_local_ds.dart
import 'package:hive_flutter/hive_flutter.dart';

abstract class RadioFavoritesLocalDataSource {
  /// Station ids, newest favorite first.
  List<String> getFavoriteIds();
  bool isFavorite(String stationId);
  Future<void> add(String stationId);
  Future<void> remove(String stationId);
}

class RadioFavoritesLocalDataSourceImpl
    implements RadioFavoritesLocalDataSource {
  RadioFavoritesLocalDataSourceImpl(this._box);

  static const boxName = 'radio_favorites';

  /// key = station id, value = millisecondsSinceEpoch when favorited
  final Box<int> _box;

  @override
  List<String> getFavoriteIds() {
    final entries = _box.toMap().entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.map((e) => e.key.toString()).toList();
  }

  @override
  bool isFavorite(String stationId) => _box.containsKey(stationId);

  @override
  Future<void> add(String stationId) =>
      _box.put(stationId, DateTime.now().millisecondsSinceEpoch);

  @override
  Future<void> remove(String stationId) => _box.delete(stationId);
}
