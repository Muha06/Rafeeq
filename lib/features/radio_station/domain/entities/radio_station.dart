import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';

class RadioStation {
  final String id;
  final String name;
  final String streamUrl;
  final String? imageUrl;
  final bool isActive;
  final RadioAudioCategory category;
  final DateTime createdAt;

  const RadioStation({
    required this.id,
    required this.name,
    required this.streamUrl,
    this.imageUrl,
    required this.isActive,
    required this.category,
    required this.createdAt,
  });
}
