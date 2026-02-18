import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/entities/current_track_entity.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/entities/reciter_entity.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/repos/quran_audio_repo.dart';

class GetSurahAudioTrack {
  final QuranAudioRepository repo;

  const GetSurahAudioTrack(this.repo);

  Future<QuranTrackEntity> call({
    required int surahId,
    required String surahName,
    required ReciterEntity reciter,
  }) {
    return repo.getSurahTrack(
      surahId: surahId,
      surahName: surahName,
      reciter: reciter,
    );
  }
}
