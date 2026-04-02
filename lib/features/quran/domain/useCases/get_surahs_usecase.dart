import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/domain/repository/quran_repo.dart';

class GetSurahsUsecase {
  final QuranRepository repository;

  GetSurahsUsecase({required this.repository});

  Future<List<Surah>> call() {
    return repository.getSurahs();
  }
}
