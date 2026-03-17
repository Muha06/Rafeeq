import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/domain/repository/surah_repo.dart';

class GetSurahsUseCase {
  final SurahRepository repository;

  GetSurahsUseCase({required this.repository});

  /// Fetch all Surahs
  List<Surah> call() {
    try {
      final surahs = repository.getSurahs();
      return surahs;
    } catch (e) {
      // Rethrow, UI will handle errors
      throw Exception('Failed to fetch Surahs: $e');
    }
  }
}
