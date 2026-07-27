import 'package:rafeeq/features/quran_audio/data/models/hive/reciter_playlist_tracks_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReciterPlaylistLocalDataSource  {
  final Box<ReciterPlaylistTracksHive> box;

  const ReciterPlaylistLocalDataSource ({required this.box});

  Future<ReciterPlaylistTracksHive?> getPlaylistTracks(int reciterId) async {
    return box.get(reciterId);
  }

  Future<void> savePlaylistTracks(
    ReciterPlaylistTracksHive playlistTracks,
  ) async {
    await box.put(playlistTracks.reciterId, playlistTracks);
  }

  Future<void> deletePlaylistTracks(int reciterId) async {
    await box.delete(reciterId);
  }

  Future<void> clear() async {
    await box.clear();
  }
}
