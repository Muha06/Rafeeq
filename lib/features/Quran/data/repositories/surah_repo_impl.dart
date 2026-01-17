import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/Quran/data/dataSources/Quran_remote_ds.dart';
import 'package:rafeeq/features/Quran/data/models/surah_dto.dart';
import 'package:rafeeq/features/Quran/data/models/surah_hive.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/domain/repository/surah_repo.dart';

class SurahRepositoryImpl implements SurahRepository {
  final QuranApiService apiService;

  SurahRepositoryImpl({required this.apiService});

  //GET SURAH FROM API/LOCAL(HIVE)
  @override
  Future<List<Surah>> getSurahs() async {
    try {
      // 1️⃣ Try local first
      final localHiveSurahs = _getSurahsFromLocal();

      if (localHiveSurahs.isNotEmpty) {
        return localHiveSurahs.map((h) {
          return Surah(
            id: h.id, // or h.number if you kept that name
            nameArabic: h.nameArabic,
            nameEnglish: h.nameEnglish,
            nameTransliteration: h.nameTransliteration,
            versesCount: h.versesCount,
            isMeccan: h.isMeccan,
          );
        }).toList();
      }

      // 2️⃣ Local empty → fetch from API
      final List<SurahDto> dtos = await apiService.fetchSurahs();

      final surahs = dtos.map((dto) => dto.toEntity()).toList();

      // 3️⃣ Save to Hive
      await saveSurahsTLocal(surahs);

      //sort surahs
      surahs.sort((a, b) => a.id.compareTo(b.id));

      // 4️⃣ Return fresh data
      return surahs;
    } catch (e, st) {
      if (kDebugMode) {
        print('Error fetching Surahs: $e');
        print(st);
      }
      throw Exception('Failed to get Surahs');
    }
  }
}

//GET SURAHS FROM LOCAL
List<SurahHive> _getSurahsFromLocal() {
  final box = Hive.box<SurahHive>('surahs');

  if (box.isEmpty) return [];

  return box.values.toList();
}

Future<void> saveSurahsTLocal(List<Surah> surahs) async {
  final box = Hive.box<SurahHive>('surahs');

  for (final surah in surahs) {
    await box.put(
      surah.id,
      SurahHive(
        id: surah.id,
        nameArabic: surah.nameArabic,
        nameEnglish: surah.nameEnglish,
        nameTransliteration: surah.nameTransliteration,
        versesCount: surah.versesCount,
        isMeccan: surah.isMeccan,
      ),
    );
  }

  print('✅ Surahs saved from API to Hive!, ${box.length}');
}
