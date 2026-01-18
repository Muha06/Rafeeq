import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';

class GetAdhkarsUsecase {
  final AdhkarRepository repo;
  const GetAdhkarsUsecase({required this.repo});

  Future<List<Dhikr>> call(String assetPath) {
    return repo.getAdhkars(assetPath);
  }
}
