import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/repository/quran_repo.dart';

class FetchAyahsUseCase {
  final QuranRepository repository;

  FetchAyahsUseCase({required this.repository});

  Future<List<Ayah>> call({required int surahId}) async {
    return repository.getAyahs(surahId);
  }
}
