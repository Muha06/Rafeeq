import 'package:rafeeq/features/radio_station/domain/entities/radio_station.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';

class RadioStationModel {
  final String id;
  final String name;
  final String streamUrl;
  final String? imageUrl;
  final String category;
  final bool isActive;
  final DateTime createdAt;

  const RadioStationModel({
    required this.id,
    required this.name,
    required this.streamUrl,
    this.imageUrl,
    required this.category,
    required this.isActive,
    required this.createdAt,
  });

  factory RadioStationModel.fromJson(Map<String, dynamic> json) {
    return RadioStationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      streamUrl: json['stream_url'] as String,
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  RadioStation toEntity() {
    return RadioStation(
      id: id,
      name: name,
      streamUrl: streamUrl,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: createdAt,
      category: RadioAudioCategoryX.fromDb(category),
    );
  }
}
