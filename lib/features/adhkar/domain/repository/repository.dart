import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';

abstract class DhikrTextRepository {
  Future<List<DhikrEntity>> getDhikrByCategoryId(
    int categoryId,
  ); //fetches categoory for an id
  Future<List<DhikrEntity>> getDhikrByCategoryIds(List<int> ids); 
}
