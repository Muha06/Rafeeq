import 'package:rafeeq/features/quran/data/dataSources/quran_local_ds.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/domain/repository/quran_repo.dart';

class QuranRepoImpl implements QuranRepository {
  final Future<QuranLocalDataSource> localDs;

  QuranRepoImpl({required this.localDs});

  @override
  Future<List<Ayah>> getAyahs(int surahId) async {
    final ds = await localDs;
    return await ds.getAyahs(surahId);
  }

  @override
  Future<List<Surah>> getSurahs() async {
    final ds = await localDs;
    return ds.getSurahs();
  }
}
