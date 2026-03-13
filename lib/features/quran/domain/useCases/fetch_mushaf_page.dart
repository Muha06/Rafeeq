import 'package:rafeeq/features/quran/domain/entities/mushaf_page.dart';
import 'package:rafeeq/features/quran/domain/repository/ayah_repo.dart';

class FetchMushafPageUseCase {
  final AyahRepository repository;

  FetchMushafPageUseCase({required this.repository});

  Future<MushafPage> call({required int page}) async {
    return repository.fetchMushafPage(page);
  }
}
