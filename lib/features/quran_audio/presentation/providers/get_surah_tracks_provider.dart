import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/reciter_entity.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/surah_track.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/wiring_providers.dart';

final surahTracksProvider =
    FutureProvider.family<List<SurahTrack>, ReciterEntity>((ref, reciter) {
      final usecase = ref.watch(getSurahAudioTrackUseCaseProvider);

      return usecase.call(reciter: reciter);
    });
