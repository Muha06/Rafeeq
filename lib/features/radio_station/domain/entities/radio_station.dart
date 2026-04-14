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

  //Display Image
  String get displayImage {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl!;
    }

    // fallback based on category
    switch (category) {
      case RadioAudioCategory.quran:
        return "assets/images/quran_default.jpg";
      case RadioAudioCategory.hadith:
        return "assets/images/hadith_default.jpg";
      case RadioAudioCategory.tafsir:
        return "assets/images/tafsir_default.jpg";
      case RadioAudioCategory.adhkar:
        return "assets/images/adhkar_default.jpg";
      case RadioAudioCategory.seerah:
        return "assets/images/seerah_default.jpg";
      case RadioAudioCategory.fiqh:
        return "assets/images/fiqh_default.jpg";
      case RadioAudioCategory.qisas:
        return "assets/images/stories_default.jpg";
      case RadioAudioCategory.fatwa:
        return "assets/images/fatwa_default.jpg";
    }
  }
}
