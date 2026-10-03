import 'package:rafeeq/features/quran_audio/domain/entities/surah_track.dart';

class AudioFileDto {
  final int id;
  final int chapterId;
  final double? fileSize;
  final String? format;
  final String audioUrl;

  const AudioFileDto({
    required this.id,
    required this.chapterId,
    required this.audioUrl,
    this.fileSize,
    this.format,
  });

  factory AudioFileDto.fromJson(Map<String, dynamic> json) {
    return AudioFileDto(
      id: json['id'] as int,
      chapterId: json['chapter_id'] as int,
      audioUrl: json['audio_url'] as String,
      fileSize: (json['file_size'] as num?)?.toDouble(),
      format: json['format'] as String?,
    );
  }

  SurahTrack toSurahTrack({
    required int reciterId,
    required int surahId,
    required String surahName,
    required String reciterName,
  }) {
    return SurahTrack(
      trackId: 'quran:$reciterId:$surahId',
      surahId: chapterId,
      surahName: surahName,
      reciterId: reciterId,
      reciterName: reciterName,
      url: audioUrl,
    );
  }
}
