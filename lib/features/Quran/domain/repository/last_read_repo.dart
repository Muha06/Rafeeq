import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';

abstract class LastReadRepository {
  Future<void> saveLastRead(LastReadAyah lastRead);
  LastReadAyah? getLastRead(int surahId);
  Future<void> removeLastRead(int surahId);
}
