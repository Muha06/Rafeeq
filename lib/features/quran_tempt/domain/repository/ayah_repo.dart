import 'package:rafeeq/features/quran_tempt/domain/entities/ayah.dart';
//THE CONTRACT
abstract class AyahRepository {
  /// Fetch ayahs for a surah
  Future<List<Ayah>> fetchAyahs(int surahId);
}
