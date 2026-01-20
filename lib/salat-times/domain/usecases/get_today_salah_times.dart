import 'package:rafeeq/salat-times/domain/entities/salah_times.dart';
import 'package:rafeeq/salat-times/domain/repository/get_today_salah_times_repo.dart';

class GetTodaySalahTimes {
  final SalahTimesRepository repo;

  const GetTodaySalahTimes(this.repo);

  Future<SalahTimesEntity> call({
    required String city,
    required String country,
    int method = 3,
  }) {
    return repo.getTodayByCity(city: city, country: country, method: method);
  }
}
