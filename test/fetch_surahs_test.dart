import 'package:flutter/cupertino.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_local_ds.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';

void main() async {
  test('Ayahs returns a list of Ayah', () async {
    final local = QuranLocalDataSourceImpl();

    final ayahs = await local.getAyahs(1);

    debugPrint("Surah ${ayahs.length} ayahs fetched successfully");
    expect(ayahs, isA<List<Ayah>>());
  });
}


