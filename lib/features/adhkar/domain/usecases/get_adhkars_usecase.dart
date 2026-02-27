import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';

class GetAdhkarsUsecase {
  final DhikrTextRepository repo;
  const GetAdhkarsUsecase({required this.repo});

  Future<List<DhikrEntity>> call(int categoryId) {
    return repo.getDhikrByCategoryId(categoryId);
  }
}
