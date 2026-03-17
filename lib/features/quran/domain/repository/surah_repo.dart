import 'package:rafeeq/features/quran/domain/entities/surah.dart';

abstract class SurahRepository {
  /// Returns the list of Surahs
  List<Surah> getSurahs();
}
