import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/quran_tempt/data/dataSources/quran_text_remote_ds.dart';
import 'package:rafeeq/features/quran_tempt/data/models/ayah_hive.dart';
import 'package:rafeeq/features/quran_tempt/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran_tempt/domain/repository/ayah_repo.dart';

class AyahRepositoryImpl implements AyahRepository {
  final QuranTextApiService remoteDS;

  AyahRepositoryImpl({required this.remoteDS});

  @override
  Future<List<Ayah>> fetchAyahs(int surahId) async {
    try {
      //FIRST CHECK LOCAL
      final localHiveAyahs = _getAyahsFromLocal()
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
}

List<AyahHive> _getAyahsFromLocal() {
  final box = Hive.box<AyahHive>('ayahs');

  if (box.isEmpty) return [];

  return box.values.toList();
}

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
          textTransliteration: ayah.transliteration
        ),
      ),
    ),
  );

  print('✅ ayahs saved from API to Hive!, ${box.length}');
}
