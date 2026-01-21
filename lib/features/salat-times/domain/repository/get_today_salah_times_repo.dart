import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';

abstract class SalahTimesRepository {
  Future<SalahTimesEntity> getTodayByCity({
    required String city,
    required String country,
    int method,
  });
}
