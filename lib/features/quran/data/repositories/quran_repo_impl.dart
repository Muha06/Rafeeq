import 'package:rafeeq/features/quran/data/dataSources/quran_local_ds.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah_info.dart';
import 'package:rafeeq/features/quran/domain/repository/quran_repo.dart';

class QuranRepoImpl implements QuranRepository {
  final QuranLocalDataSource localDs;

  QuranRepoImpl({required this.localDs});

  @override
  Future<SurahInfo?> getSurahInfo(int surahId) async {
    return await localDs.getSurahInfo(surahId);
  }

  @override
  Future<List<Ayah>> getAyahs(int surahId) async {
    return await localDs.getAyahs(surahId);
  }

  @override
  Future<List<Surah>> getSurahs() async {
    return localDs.getSurahs();
  }
}
