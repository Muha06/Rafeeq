import 'package:rafeeq/features/quran_goal/data/models/quran_audio/data/datasources/quran_audio_remote_ds.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/entities/current_track_entity.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/entities/reciter_entity.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_audio/domain/repos/quran_audio_repo.dart';

class QuranAudioRepositoryImpl implements QuranAudioRepository {
  final QuranAudioApiService api;

  QuranAudioRepositoryImpl({required this.api});

  //fetches audioFile from api returns Quran track used by UI/player
  @override
  Future<QuranTrackEntity> getSurahTrack({
    required int surahId,
    required String surahName,
    required ReciterEntity reciter,
  }) async {
    final audioFile = await api.fetchChapterAudioFile(
      reciterId: reciter.id,
      chapterNumber: surahId,
    );

    return QuranTrackEntity.build(
      surahId: surahId,
      surahName: surahName,
      reciter: reciter,
      audioFile: audioFile,
    );
  }
}
