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

/// Save last read ayah
Future<void> saveLastRead(LastReadAyah lastRead) async {
  debugPrint(
    'Saving last read: surahId=${lastRead.surahId}, ayahNumber=${lastRead.ayahNumber}',
  );
  await lastReadBox.put('lastRead', lastRead.toMap());
}

/// Get last read ayah
LastReadAyah? getLastRead() {
  final data = lastReadBox.get('lastRead');
  if (data != null && data is Map) {
    return LastReadAyah.fromMap(data);
  }
  return null;
}
