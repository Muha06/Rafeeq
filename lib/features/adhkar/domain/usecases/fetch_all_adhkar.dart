import 'package:rafeeq/features/adhkar/domain/entities/dhikr_entity.dart';
import 'package:rafeeq/features/adhkar/domain/repositories/adkar_repo.dart';

class FetchAllAdhkarUsecase {
  final AdkarRepo repo;
  FetchAllAdhkarUsecase({required this.repo});

  Future<List<Dhikr>> call(String subcategoryId) async {
    return await repo.fetchAllDhikrs(subcategoryId);
  }
}
