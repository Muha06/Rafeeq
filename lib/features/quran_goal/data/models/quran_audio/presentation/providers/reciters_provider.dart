import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_audio/data/datasources/reciters_seed.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/entities/reciter_entity.dart';
import 'package:riverpod/legacy.dart';

final quranRecitersProvider = Provider<List<ReciterEntity>>((ref) {
  return kQuranRecitersSeed;
});

final selectedReciterProvider = StateProvider<ReciterEntity>((ref) {
  return kQuranRecitersSeed.first;
});
