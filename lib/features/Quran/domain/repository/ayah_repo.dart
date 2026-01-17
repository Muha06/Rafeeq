import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';
//THE CONTRACT
abstract class AyahRepository {
  /// Fetch ayahs for a surah
  Future<List<Ayah>> fetchAyahs(int surahId);
}
