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

  Map<String, dynamic> toJson() => {
    'id': id,
    'chapter_id': chapterId,
    'file_size': fileSize,
    'format': format,
    'audio_url': audioUrl,
  };
}
