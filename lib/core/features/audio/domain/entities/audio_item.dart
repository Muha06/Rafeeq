import 'package:equatable/equatable.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';

class AudioItem extends Equatable {
  const AudioItem({
    required this.id,
    required this.title,
    required this.url,
    required this.sourceType,
    this.imageUrl,
    this.artist,
  });

  final String id;
  final String title;
  final String url;
  final String? artist;
  final String? imageUrl;
  final AudioSourceType sourceType;

  @override
  List<Object?> get props => [id, title, url, artist, imageUrl, sourceType];
}
