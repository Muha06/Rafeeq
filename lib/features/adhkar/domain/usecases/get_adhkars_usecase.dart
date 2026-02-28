import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';

class GetGroupedAdhkarsUsecase {
  final DhikrTextRepository repo;
  const GetGroupedAdhkarsUsecase({required this.repo});

  Future<List<DhikrEntity>> call(List<int> categoryIds) {
    return repo.getDhikrByCategoryIds(categoryIds);
  }
}
