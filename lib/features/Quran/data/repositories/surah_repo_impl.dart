import 'package:flutter/foundation.dart';
import 'package:rafeeq/features/Quran/data/dataSources/Quran_remote_ds.dart';
import 'package:rafeeq/features/Quran/data/models/surahDto.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/domain/repository/surah_repo.dart';

class SurahRepositoryImpl implements SurahRepository {
  final QuranApiService apiService;

  SurahRepositoryImpl({required this.apiService});

  @override
  Future<List<Surah>> getSurahs() async {
    try {
      //call the remoteDS to fetch surahs
      final List<SurahDto> dtos = await apiService.fetchSurahs();

      // Convert DTOs to Entity
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e, st) {
      if (kDebugMode) {
        print('Error fetching Surahs: $e');
        print(st);
      }
      throw Exception('Failed to get Surahs: $e');
    }
  }
}
