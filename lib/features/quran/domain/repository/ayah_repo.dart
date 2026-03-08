import 'package:rafeeq/features/quran/data/models/ayah_hive.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/mushaf_page.dart';

//THE CONTRACT
abstract class AyahRepository {
  /// Fetch ayahs for a surah
  Future<List<Ayah>> fetchAyahs(int surahId);
  Future<void> saveAyahsToLocal(List<Ayah> ayahs);
  List<AyahHive> getAyahsFromLocal();
  Future<void> prefetchAllAyahs();
  Future<MushafPage> fetchMushafPage(int page);
}
