import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/Quran/domain/repository/ayah_repo.dart';

class FetchAyahsUseCase {
  final AyahRepository repository;

  FetchAyahsUseCase({required this.repository});

  Future<List<Ayah>> call({
    required int surahId,
    int page = 1,
    int limit = 20,
  }) async {
    return repository.fetchAyahs(surahId, page: page, limit: limit);
  }
}
