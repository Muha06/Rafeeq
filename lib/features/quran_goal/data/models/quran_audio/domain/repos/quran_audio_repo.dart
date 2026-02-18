import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/entities/current_track_entity.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/entities/reciter_entity.dart';

abstract class QuranAudioRepository {
  Future<QuranTrackEntity> getSurahTrack({
    required int surahId,
    required String surahName,
    required ReciterEntity reciter,
  });
}
