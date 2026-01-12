import 'package:flutter/cupertino.dart';
import 'package:rafeeq/features/Quran/data/dataSources/last_read_local_ds.dart';
import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/Quran/domain/repository/last_read_repo.dart';

class LastReadRepositoryImpl implements LastReadRepository {
  final LastReadLocalDataSource localDataSource;

  LastReadRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveLastRead(LastReadAyah lastRead) {
    final ayahNumber = lastRead.ayahNumber;
    final lastAyah = lastRead.verseCount;
    if (ayahNumber >= lastAyah) {
      debugPrint(
        'Skipping save for ayah ${lastRead.ayahNumber}, last ayah ${lastRead.verseCount}',
      );
      return Future.value(); // Do not save if it's the last ayah
      
    } else {
      debugPrint(
        'Saved last read: Surah  ${lastRead.surahId}, Ayah ${lastRead.ayahNumber}',
      );
      return localDataSource.saveLastRead(lastRead);
    }
  }

  @override
  LastReadAyah? getLastRead(int surahId) {
    return localDataSource.getLastRead(surahId);
  }

  @override
  Future<void> removeLastRead(int surahId) {
    return localDataSource.removeLastRead(surahId);
  }

  @override
  Future<List<LastReadAyah>> getAllLastReads() {
    return localDataSource.getAllLastReads();
  }
}
