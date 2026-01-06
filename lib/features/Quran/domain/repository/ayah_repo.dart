import 'package:rafeeq/features/Quran/data/dataSources/Quran_remote_ds.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';

class AyahRepository {
  final QuranApiService remoteDS;

  AyahRepository({required this.remoteDS});

  /// Fetch ayahs for a surah and convert DTO → Entity
  Future<List<Ayah>> fetchAyahs(
    int surahId, {
    int page = 1,
    int limit = 20,
  }) async {
    final ayahDtos = await remoteDS.fetchAyahs(
      surahId: surahId,
      page: page,
      limit: limit,
    );

    //convert to entity
    return ayahDtos.map((dto) => dto.toEntity()).toList();
  }
}
