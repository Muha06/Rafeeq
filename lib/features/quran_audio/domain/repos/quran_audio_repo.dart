import 'package:rafeeq/features/quran_audio/domain/entities/surah_track.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/reciter_entity.dart';

abstract class QuranAudioRepository {
  Future<List<SurahTrack>> getSurahTracks({required ReciterEntity reciter});
}
