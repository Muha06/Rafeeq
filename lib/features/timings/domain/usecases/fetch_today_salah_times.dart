import 'package:rafeeq/core/features/location/domain/user_location.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/domain/repository/get_today_salah_times_repo.dart';

class FetchTodaySalahTimes {
  final FetchSalahTimesRepo repo;

  const FetchTodaySalahTimes(this.repo);

  Future<SalahTimesEntity> fetchTodayByCoords({
    required UserLocation userLocation,
    int method = 3,
  }) {
    return repo.fetchTodayByCoords(userLocation: userLocation, method: method);
  }
}
