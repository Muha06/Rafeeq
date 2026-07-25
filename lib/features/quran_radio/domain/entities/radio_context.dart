import 'package:rafeeq/features/quran_radio/domain/entities/radio_station.dart';

class RadioPlaybackSession {
  const RadioPlaybackSession({
    required this.stations,
    required this.currentIndex,
  });

  final List<RadioStation> stations;
  final int currentIndex;

  RadioPlaybackSession copyWith({
    List<RadioStation>? stations,
    int? currentIndex,
  }) {
    return RadioPlaybackSession(
      stations: stations ?? this.stations,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
