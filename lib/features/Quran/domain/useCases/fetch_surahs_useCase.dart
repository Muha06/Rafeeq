import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/domain/repository/surah_repo.dart';

class GetSurahsUseCase {
  final SurahRepository repository;

  GetSurahsUseCase({required this.repository});

  /// Fetch all Surahs
  Future<List<Surah>> execute() async {
    try {
      final surahs = await repository.getSurahs();
      return surahs;
    } catch (e) {
      // Rethrow, UI will handle errors
      throw Exception('Failed to fetch Surahs: $e');
    }
  }
}
