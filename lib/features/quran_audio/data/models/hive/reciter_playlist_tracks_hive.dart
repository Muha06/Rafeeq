import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/quran_audio/data/models/hive/surah_track_hive.dart';

part 'generated/reciter_playlist_tracks_hive.g.dart';

@HiveType(typeId: 37)
class ReciterPlaylistTracksHive extends HiveObject {
  @HiveField(0)
  final int reciterId;

  @HiveField(1)
  final List<SurahTrackHive> tracks;

  @HiveField(2)
  final DateTime cachedAt;

  ReciterPlaylistTracksHive({
    required this.reciterId,
    required this.tracks,
    required this.cachedAt,
  });
}
