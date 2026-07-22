import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_station.dart';

final currentStationProvider = StateProvider<RadioStation?>((_) => null);
