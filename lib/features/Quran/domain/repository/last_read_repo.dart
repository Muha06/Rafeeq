import 'package:rafeeq/features/quran/domain/entities/last_read_ayah.dart';

abstract class LastReadRepository {
  Future<void> saveLastRead(LastReadAyah lastRead);
  LastReadAyah? getLastRead(int surahId);
  Future<void> removeLastRead(int surahId);
  Future<List<LastReadAyah>> getAllLastReads();
}
