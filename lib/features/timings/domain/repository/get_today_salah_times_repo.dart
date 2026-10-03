import 'package:rafeeq/core/features/location/domain/user_location.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';

abstract class FetchSalahTimesRepo {
  Future<SalahTimesEntity> fetchTodayByCoords({
    required UserLocation userLocation,
    int method,
  });
}
