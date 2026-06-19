import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_category.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_entity.dart';
 
abstract class AdkarRepo {
  Future<List<DhikrCategory>> fetchAllCategories();
   Future<List<Dhikr>> fetchAllDhikrs(String categoryId);
}