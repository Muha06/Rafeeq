import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';

import '../entities/radio_station.dart';

abstract class RadioRepository {
  Future<List<RadioStation>> getRadioStations();

  Future<List<RadioStation>> getByCategory(RadioAudioCategory category);
}
