import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_category.dart';
import 'package:rafeeq/features/adhkar_02/domain/repositories/adkar_repo.dart';

class FetchAllCategories {
  final AdkarRepo repository;
  FetchAllCategories({required this.repository});

  Future<List<DhikrCategory>> call() async {
    return repository.fetchAllCategories();
  }
}
