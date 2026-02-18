import 'package:rafeeq/features/quran_goal/data/models/quran_audio/data/models/audio_file_dto.dart';

//converts raw response to DTO (optional)
class ChapterRecitationResponseDto {
  final AudioFileDto audioFile;

  const ChapterRecitationResponseDto({required this.audioFile});

  factory ChapterRecitationResponseDto.fromJson(Map<String, dynamic> json) {
    return ChapterRecitationResponseDto(
      audioFile: AudioFileDto.fromJson(
        json['audio_file'] as Map<String, dynamic>,
      ),
    );
  }
}
