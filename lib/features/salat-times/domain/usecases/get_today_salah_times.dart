import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';
import 'package:rafeeq/features/salat-times/domain/repository/get_today_salah_times_repo.dart';

class GetTodaySalahTimes {
  final SalahTimesRepository repo;

  const GetTodaySalahTimes(this.repo);

  Future<SalahTimesEntity> call({
    required double latitude,
    required double longitude,
    required String city,
    required String country,
    int method = 3,
  }) {
    return repo.getTodayByCoords(
      latitude: latitude,
      longitude: longitude,
      city: city,
      country: country,
      method: method,
    );
  }

  Future<SalahTimesEntity> callByCity({
    required String city,
    required String country,
    int method = 3,
  }) {
    return repo.getTodayByCity(city: city, country: country, method: method);
  }
}
