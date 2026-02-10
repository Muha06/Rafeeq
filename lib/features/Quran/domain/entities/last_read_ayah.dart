import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LastReadAyah {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final int verseCount;
  final DateTime updatedAt;

  const LastReadAyah({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.verseCount,
    required this.updatedAt,
  });

  /// Convert to Map for Hive
  Map<String, dynamic> toMap() {
    return {
      'surahId': surahId,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'verseCount': verseCount,
      'updatedAt': updatedAt,
    };
  }

  /// Convert from Map
  factory LastReadAyah.fromMap(Map<dynamic, dynamic> map) {
    return LastReadAyah(
      surahId: map['surahId'] as int,
      surahName: map['surahName'] as String,
      ayahNumber: map['ayahNumber'] as int,
      verseCount: map['verseCount'] as int,
      updatedAt: map['updatedAt'] as DateTime,
    );
  }
}

/// Open Hive box once
final lastReadBox = Hive.box('lastReadBox');

/// SAVE last read
Future<void> saveLastRead(LastReadAyah lastRead) async {
  await lastReadBox.put(lastRead.surahId, lastRead.toMap());
  debugPrint(
    'Saved last read for Surah ${lastRead.surahName} (${lastRead.surahId}), Ayah ${lastRead.ayahNumber}',
  );
}

/// GET last read
LastReadAyah? getLastRead(int surahId) {
  final data = lastReadBox.get(surahId);
  if (data != null && data is Map) return LastReadAyah.fromMap(data);
  return null;
}

/// REMOVE last read
Future<void> removeLastReadHive(int surahId) async {
  if (lastReadBox.containsKey(surahId)) {
    await lastReadBox.delete(surahId);
    debugPrint('Last-read for Surah $surahId deleted from Hive');
  }
}
