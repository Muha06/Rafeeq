//abstract
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';

abstract class AdhkarRepository {
  Future<List<Dhikr>> getAdhkars(String assetPath);
}
