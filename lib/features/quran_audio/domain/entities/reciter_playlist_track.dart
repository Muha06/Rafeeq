import 'package:rafeeq/features/quran_audio/domain/entities/surah_track.dart';

class ReciterPlaylistTracks {
  final int reciterId;
  final List<SurahTrack> tracks;
  final DateTime cachedAt;

  const ReciterPlaylistTracks({
    required this.reciterId,
    required this.tracks,
    required this.cachedAt,
  });
}
