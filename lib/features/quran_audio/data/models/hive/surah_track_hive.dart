import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/surah_track.dart';

part 'generated/surah_track_hive.g.dart';

@HiveType(typeId: 38)
class SurahTrackHive extends HiveObject {
  @HiveField(0)
  final String trackId;

  @HiveField(1)
  final int surahId;

  @HiveField(2)
  final String surahName;

  @HiveField(3)
  final int reciterId;

  @HiveField(4)
  final String reciterName;

  @HiveField(5)
  final String url;

  @HiveField(6)
  final int? audioFileId;

  @HiveField(7)
  final double? fileSize;

  @HiveField(8)
  final String? format;

  SurahTrackHive({
    required this.trackId,
    required this.surahId,
    required this.surahName,
    required this.reciterId,
    required this.reciterName,
    required this.url,
    this.audioFileId,
    this.fileSize,
    this.format,
  });

  SurahTrack toEntity() {
    return SurahTrack(
      trackId: trackId,
      surahId: surahId,
      surahName: surahName,
      reciterId: reciterId,
      reciterName: reciterName,
      url: url,
      audioFileId: audioFileId,
      fileSize: fileSize,
      format: format,
    );
  }
}
