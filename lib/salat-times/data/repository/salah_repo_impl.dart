import 'package:rafeeq/salat-times/data/datasources/salah_remote_ds.dart';
import 'package:rafeeq/salat-times/data/models/model_2_entity_mapper.dart';
import 'package:rafeeq/salat-times/domain/entities/salah_times.dart';
import 'package:rafeeq/salat-times/domain/repository/get_today_salah_times_repo.dart';

class SalahTimesRepositoryImpl implements SalahTimesRepository {
  final SalahRemoteDataSource remote;

  const SalahTimesRepositoryImpl({required this.remote});

  @override
  Future<SalahTimesEntity> getTodayByCity({
    required String city,
    required String country,
    int method = 3,
  }) async {
    final model = await remote.fetchTodayByCity(
      city: city,
      country: country,
      method: method,
    );

    return model.toEntity();
  }
}
