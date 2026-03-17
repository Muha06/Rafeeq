 import 'package:rafeeq/features/quran/data/dataSources/quran_text_local.dart';
 import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/domain/repository/surah_repo.dart';

class SurahRepositoryImpl implements SurahRepository {
  final QuranLocalDataSource local;

  SurahRepositoryImpl({required this.local});

  //GET SURAH FROM API/LOCAL(HIVE)
  @override
  List<Surah> getSurahs() {
    return local.getAllSurahs();
  }
}
