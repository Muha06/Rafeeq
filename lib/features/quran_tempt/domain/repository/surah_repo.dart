import 'package:rafeeq/features/quran_tempt/domain/entities/surah.dart';

abstract class SurahRepository {
  /// Returns the list of Surahs
  Future<List<Surah>> getSurahs();
}
