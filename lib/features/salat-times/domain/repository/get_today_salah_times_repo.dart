import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';

abstract class SalahTimesRepository {
  Future<SalahTimesEntity> getTodayByCity({
    required String city,
    required String country,
    int method,
  });

   Future<SalahTimesEntity> getTodayByCoords({
    required double latitude,
    required double longitude,
    required String city,
    required String country,
    int method,
  });
}
