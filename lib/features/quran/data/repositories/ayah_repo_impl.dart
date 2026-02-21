import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_text_remote_ds.dart';
import 'package:rafeeq/features/quran/data/models/ayah_hive.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/repository/ayah_repo.dart';

class AyahRepositoryImpl implements AyahRepository {
  final QuranTextApiService remoteDS;

  AyahRepositoryImpl({required this.remoteDS});

  @override
  Future<void> prefetchAllAyahs() async {
    for (int surahId = 1; surahId <= 114; surahId++) {
      try {
        await Future.microtask(
          () => fetchAyahs(surahId),
        ); // repo handles local check + save

        debugPrint('Surah $surahId downloaded ✅');
      } catch (e) {
        debugPrint('Failed to download surah $surahId: $e');
      }
    }
    debugPrint('All surahs downloaded 🌙');
  }

  @override
  Future<List<Ayah>> fetchAyahs(int surahId) async {
    try {
      //FIRST CHECK LOCAL
      final localHiveAyahs = getAyahsFromLocal()
          .where((ayah) => ayah.surahId == surahId)
          .toList();

      if (localHiveAyahs.isNotEmpty) {
        //Return the local ayahs
        return localHiveAyahs.map((localAyah) => localAyah.toEntity()).toList();
      }

      //else -> fetch
      final ayahDtos = await remoteDS.fetchAyahs(surahId: surahId);

      final ayahs = ayahDtos.map((dto) => dto.toEntity()).toList();

      //save to local
      await saveAyahsToLocal(ayahs);

      // convert DTO → Entity
      return ayahs;
    } catch (e, st) {
      if (kDebugMode) {
        print('Error fetching ayahs: $e');
        print(st);
      }
      throw Exception('Failed to get ayahs');
    }
  }

  @override
  Future<void> saveAyahsToLocal(List<Ayah> ayahs) async {
    final box = Hive.box<AyahHive>('ayahs');

    await Future.wait(
      ayahs.map(
        (ayah) => box.put(
          ayah.id,
          AyahHive(
            id: ayah.id,
            textArabic: ayah.textArabic,
            textEnglish: ayah.textEnglish,
            ayahNumber: ayah.ayahNumber,
            surahId: ayah.surahId,
            textTransliteration: ayah.transliteration,
          ),
        ),
      ),
    );
  }

  @override
  List<AyahHive> getAyahsFromLocal() {
    final box = Hive.box<AyahHive>('ayahs');

    if (box.isEmpty) return [];

    return box.values.toList();
  }
}
