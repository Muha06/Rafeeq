import 'package:rafeeq/features/quran_radio/domain/repository/radio_favorites_repo.dart';
import '../datasources/radio_favorites_local_ds.dart';

class RadioFavoritesRepositoryImpl implements RadioFavoritesRepository {
  RadioFavoritesRepositoryImpl(this._local);

  final RadioFavoritesLocalDataSource _local;

  @override
  List<String> getFavoriteIds() => _local.getFavoriteIds();

  @override
  Future<void> add(String stationId) => _local.add(stationId);

  @override
  Future<void> remove(String stationId) => _local.remove(stationId);
}
