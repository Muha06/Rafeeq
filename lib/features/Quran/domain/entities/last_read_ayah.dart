import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LastReadAyah {
  final int surahId;
  final int ayahNumber;

  const LastReadAyah({required this.surahId, required this.ayahNumber});

  /// Convert to Map for Hive
  Map<String, dynamic> toMap() {
    return {'surahId': surahId, 'ayahNumber': ayahNumber};
  }

  /// Convert from Map
  factory LastReadAyah.fromMap(Map<dynamic, dynamic> map) {
    return LastReadAyah(
      surahId: map['surahId'] as int,
      ayahNumber: map['ayahNumber'] as int,
    );
  }
}

/// Open the Hive box once in main() or a provider
final lastReadBox = Hive.box('lastReadBox');

//SAVE LAST READ
Future<void> saveLastRead(LastReadAyah lastRead) async {
  await lastReadBox.put(lastRead.surahId, lastRead.toMap());
  debugPrint('Saved last read for Surah ${lastRead.surahId}');
}

//GET LAST READ
LastReadAyah? getLastRead(int surahId) {
  final data = lastReadBox.get(surahId);
  if (data != null && data is Map) return LastReadAyah.fromMap(data);
  return null;
}

//REMOVE LAST READ
Future<void> removeLastReadHive(int surahId) async {
  if (lastReadBox.containsKey(surahId)) {
    await lastReadBox.delete(surahId);
    debugPrint('Last-read for Surah $surahId deleted from Hive');
  }
}

