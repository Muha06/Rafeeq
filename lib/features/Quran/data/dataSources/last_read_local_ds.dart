import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';

abstract class LastReadLocalDataSource {
  Future<void> saveLastRead(LastReadAyah lastRead);
  LastReadAyah? getLastRead(int surahId);
  Future<void> removeLastRead(int surahId);
  Future<List<LastReadAyah>> getAllLastReads();
}

class LastReadLocalDataSourceImpl implements LastReadLocalDataSource {
  final Box box;

  LastReadLocalDataSourceImpl(this.box);

  //SAVE Last read
  @override
  Future<void> saveLastRead(LastReadAyah lastRead) async {
    await box.put(lastRead.surahId, {
      'surahId': lastRead.surahId,
      'surahName': lastRead.surahName,
      'ayahNumber': lastRead.ayahNumber,
      'verseCount': lastRead.verseCount,
    });
  }

  //GET last read
  @override
  LastReadAyah? getLastRead(int surahId) {
    final data = box.get(surahId);
    if (data == null) return null;

    return LastReadAyah(
      surahId: data['surahId'],
      surahName: data['surahName'],
      ayahNumber: data['ayahNumber'],
      verseCount: data['verseCount'],
    );
  }

  //REMOVE last read
  @override
  Future<void> removeLastRead(int surahId) async {
    if (box.containsKey(surahId)) {
      await box.delete(surahId);
    }
  }

  //GET all last reads
  @override
  Future<List<LastReadAyah>> getAllLastReads() async {
    final lastReads = box.values
        .cast<Map>()
        .map(
          (data) => LastReadAyah(
            surahId: data['surahId'],
            surahName: data['surahName'],
            ayahNumber: data['ayahNumber'],
            verseCount: data['verseCount'],
          ),
        )
        .toList();

    return lastReads;
  }
}
