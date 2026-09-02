import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/domain/repository/get_today_salah_times_repo.dart';

class FetchTodaySalahTimes {
  final FetchSalahTimesRepo repo;

  const FetchTodaySalahTimes(this.repo);

  Future<SalahTimesEntity> fetchTodayByCoords({
    required double latitude,
    required double longitude,
    required String city,
    required String country,
    int method = 3,
  }) {
    return repo.fetchTodayByCoords(
      latitude: latitude,
      longitude: longitude,
      city: city,
      country: country,
      method: method,
    );
  }

  Future<SalahTimesEntity> fetchTodayByCity({
    required String city,
    required String country,
    int method = 3,
  }) {
    return repo.fetchTodayByCity(city: city, country: country, method: method);
  }
}
