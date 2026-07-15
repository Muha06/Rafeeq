import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';

abstract class FetchSalahTimesRepo {
  Future<SalahTimesEntity> fetchTodayByCity({
    required String city,
    required String country,
    int method,
  });

  Future<SalahTimesEntity> fetchTodayByCoords({
    required double latitude,
    required double longitude,
    required String city,
    required String country,
    int method,
  });
}
