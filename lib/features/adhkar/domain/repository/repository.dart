import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';

abstract class DhikrTextRepository {
  /// Fetch dhikr for a given category id
  Future<List<DhikrEntity>> getDhikrByCategoryId(int categoryId);
}
