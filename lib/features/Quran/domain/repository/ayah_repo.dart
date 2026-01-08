import 'package:rafeeq/features/Quran/data/dataSources/Quran_remote_ds.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';

class AyahRepository {
  final QuranApiService remoteDS;

  AyahRepository({required this.remoteDS});

  /// Fetch ayahs for a surah and convert DTO → Entity
  Future<List<Ayah>> fetchAyahs(int surahId) async {
    final ayahDtos = await remoteDS.fetchAyahs(surahId: surahId);

    //convert to entity
    return ayahDtos.map((dto) => dto.toEntity()).toList();
  }
}
